require 'date'
require "open-uri"

class ServicesController < ApplicationController
  skip_before_filter :user_about

  def search_product_and_store_for_campus
    response_status_for_product, @products = Product.search_product_for_api(params)
    response_status_for_store, @stores = Store.search_store_for_api(params)
    @response_status = ResponseStatus.merge_status(response_status_for_product, response_status_for_store)
  end

  # app随机推荐某家店铺
  def random_recommend_store_in_campus
    @response_status, @store = Store.recommend_store_in_campus(params)
  end

  def pingpp_pay_done_for_alive
    status = 200
    begin
      event = JSON.parse(request.body.read)
      if event['type'].nil? && event['livemode'] == true
      elsif event['type'] == 'charge.succeeded'
        # 开发者在此处加入对支付异步通知的处理代码
        charge = event['data']['object']
        status = 200
        payment = Payment.new
        payment.payment_method = charge['channel'] #支付渠道
        payment.time_paid = Time.at(charge['time_paid']).to_datetime
        payment.order_id = charge['order_no']
        payment.amount = charge['amount']
        payment.transaction_no = charge['transaction_no']
        payment.charge_id = charge['id']
        payment.pingpp_info = event.to_s
        payment.save!
      else
      end
    rescue JSON::ParserError
      render :status => status
    end
  end

  def pingpp_pay_done
    status = 200
    begin
      event = JSON.parse(request.body.read)
      if event['type'].nil?
      elsif event['type'] == 'charge.succeeded'
        # 开发者在此处加入对支付异步通知的处理代码
        charge = event['data']['object']
        status = 200
        payment = Payment.new
        payment.payment_method = charge['channel'] #支付渠道
        payment.time_paid = Time.at(charge['time_paid']).to_datetime
        payment.order_id = charge['order_no']
        payment.amount = charge['amount']
        payment.transaction_no = charge['transaction_no']
        payment.charge_id = charge['id']
        payment.pingpp_info = event.to_s
        payment.save!

      else
      end
    rescue JSON::ParserError
      render :status => status
    end
  end


  def self.get_config
    {
        availableDeliveryTime: ["6:30", "7:00", "7:30" , "8:30", "9:00"],
        availablePayMethod: [{
                                 name: "支付宝",
                                 code: "alipay"
                             },
                             {
                                 name: "微信",
                                 code: "wx"
                             }],
        red_pack_available: false,
        kefu_phone: '13788982942',
        # 营业时间至 (小时)
        deadline_hour: 23,
        # 营业时间至 (分钟)
        deadline_minute: 30
    }
  end

  def basic_config
    @response_status = ResponseStatus.default_success
    @config = ServicesController.get_config
  end

  def send_login_sms_code
    @response_status = ResponseStatus.default
    @token = nil
    begin
      raise StandardError.new('手机号输入有误') if params[:phone].blank? || !RegularTest.is_phone_number(params[:phone])
      @token = TsaoUtil.send_sms_code(params[:phone], TsaoUtil::Usage::USER_SIGN_IN)
      @response_status = ResponseStatus.default_success
    rescue Exception => ex
      Rails.logger.error(ex.message)
      @response_status.message = ex.message
    end

  end


  # 下载app
  def download
    redirect_to_url = ''
    if is_iphone_device?
      #appstore
      redirect_to_url =  AppVersion::DownloadURL::IPHONE_URL
    elsif is_android_device?
      #Android版在应用宝的地址
      redirect_to_url = AppVersion::DownloadURL::ANDOIRD_URL
    end

    respond_to do |format|
      if is_iphone_device? &&  weixin_browser?

        format.html{ render layout: false }
      else
        format.html { redirect_to  redirect_to_url}
      end
    end
  end

  #
  # app更新检查
  #
  def check_update
    @response_status, @update_info = AppVersion.check_update(params)
  end

end
