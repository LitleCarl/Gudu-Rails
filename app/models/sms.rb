require 'json'
class Sms
  module TemplateID
    LoginCode = 'RSETSESEKESE'
    PayDone = 'ZL6IQABG7738'
  end

  # 返回支付时间, 订单价格, 预计送达时间
  def self.wrap_pay_done_param(order_id)
    order = Order.find(order_id)
    if order.present? && order.payment.present?
      return order.payment.time_paid.strftime('%m月%d日%H:%M'), order.price.to_s, "明日#{order.delivery_time}"
    else
      return nil, nil, nil
    end
  end

  # 智验短信平台 http://www.zhiyan.net
  def self.sms_zhiyan(mobile, use_for, template_params)
    result = :fail
    url = 'http://sms.zhiyan.net/sms/template_send.json'
    return result if url.nil?

    param = {
        apiKey: 'e4d316a72e6d435ba14e0bdb533ed669',
        appId: '03sz3t6922n7',
        mobile: mobile.to_s,
        templateId: use_for,
        param: template_params
    }

    begin
      # 针对不同的测试类型提供不同的post url
      res = nil

      url = URI.parse(url)
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json;charset=utf-8', 'Accept' => 'application/json'})
      req.body = param.to_json
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}

      res_data = JSON.parse(res.body)
      Rails.logger.info(res_data.class)
      if res_data['result'] == 'SUCCESS'
        result = :success
        Rails.logger.info('短信发送成功')
      else
        Rails.logger.info('短信发送失败:'+res_data['reason'])
      end

    rescue => e
      Rails.logger.error do
        ([e.message] + e.backtrace).join("\n")
      end unless e.blank?
    end
    return result
  end

end