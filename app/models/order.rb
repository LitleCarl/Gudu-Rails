# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  status           :integer          default("1"), not null
#  price            :decimal(10, 2)   default("0.00"), not null
#  delivery_time    :string(255)      not null
#  receiver_name    :string(255)      not null
#  receiver_phone   :string(255)      not null
#  receiver_address :string(255)      not null
#  campus_id        :integer
#  user_id          :integer
#  pay_method       :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  charge_json      :text(65535)
#  order_number     :string(255)
#  pay_price        :decimal(10, 2)   default("0.00")           # 实际支付金额
#  service_price    :decimal(10, 2)   default("0.00")           # 服务费用
#

class Order < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # mixin 管理者
  include Concerns::Management::Api::V1::OrderConcern

  # 关联学校
  belongs_to :campus

  # 关联用户
  belongs_to :user

  # 关联红包
  has_one :red_pack

  # 关联支付
  has_one :payment

  # 关联订单内容
  has_many :order_items

  # 关联优惠券 (如果订单使用了优惠券)
  has_one :coupon

  # 关联物流
  has_one :express

  # 关联快递员
  has_one :expresser, through: :express

  # 关联套餐订单中间表
  has_many :order_suits

  # 订单可能包含了套餐
  has_many :suits, through: :order_suits

  before_create :generate_order_number
  validate :check_order_fields
  after_save :check_order_status
  after_create :check_coupon

  module Status
    include Concerns::Dictionary::Module::I18n

    DEAD = 0          # 取消的订单

    NOT_PAID = 1      # 未支付

    WAITING_CONFIRM = 11      # 已支付待确认

    NOT_DELIVERED = 2 # 已确认未发货

    NOT_RECEIVED = 3  # 未收到

    NOT_COMMENTED = 4 # 未评论

    DONE = 5          # 完成

    PAYMENT_SUCCESS = [WAITING_CONFIRM, NOT_DELIVERED, NOT_RECEIVED, NOT_COMMENTED, DONE]

    # 全部
    ALL = get_all_values
  end

  module PayMethod
    include Concerns::Dictionary::Module::I18n

    WEIXIN = 'wx'

    ALIPAY = 'alipay'

    # 全部
    ALL = get_all_values
  end

  #
  # 打印当日产生订单的小票
  #
  # @param options [Hash]
  # option options [start_number] :从此订单号开始打印
  # option options [date] :选择要打印的日期
  #
  # @return [Response, Array] 状态，学校列表
  #
  def self.receipt(options)
    receipt = nil

    response = ResponseStatus.__rescue__ do |res|
      start_number = options[:start_number]
      date = options[:date] || Time.now

      orders = Order.joins(:payment).where('payments.time_paid >= ? AND payments.time_paid <= ?', date.beginning_of_day, date.end_of_day)
      orders = orders.where('orders.status = ?', Status::NOT_DELIVERED)

      if start_number.present?
        order = self.query_first_by_options(status: Status::NOT_DELIVERED, order_number: start_number)

        res.__raise__(ResponseStatus::Code::ERROR, "订单号:#{start_number}不存在") if order.blank?

        orders = orders.where('orders.id > ?', order.id)
      end

      orders = orders.order('id asc')

      orders.each do |order|

        line_items = []

        order.order_items.each do |order_item|
          line_items << ["#{order_item.product.name}(#{order_item.specification.value})", "#{order_item.quantity}份","#{order_item.quantity_multiply_price_snapshot}"]
        end

        receipt = Receipts::Receipt.new(
            id: "#{order.order_number}",
            product: '早餐巴士',
            receiver_info: {
                name: "收货人: #{order.receiver_name}",
                address: "地址: #{order.receiver_address}",
                phone: "手机: #{order.receiver_phone}",
                delivery_time: "送达时间: #{order.format_delivery_time}",
            },
            logo: Rails.root.join('app/assets/images/Icon.png'),
            line_items: line_items,
            font: {
                bold: Rails.root.join('app/assets/fonts/custom_font.ttf'),
                normal: Rails.root.join('app/assets/fonts/custom_font.ttf'),
            }
        )

        # receipt.print
        receipt.render_file("/Users/tsaojixin/Downloads/tmp/#{order.delivery_time.gsub(/:/, '')}/#{order.order_number}.pdf")
      end

    end

    return response, receipt

  end

  def self.query_by_id(options)
    order = nil

    catch_proc = proc {
      order = nil
    }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      order_id = options[:order_id]
      user = options[:user]

      res.__raise__(ResponseStatus::Code::ERROR, '缺失参数') if order_id.blank? || user.blank?

      order = self.query_first_by_options(user: user, id: order_id)
    end

    return response, order
  end

  def self.get_orders_of_user(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      #raise RestError::MissParameterError if params[:user].blank?
      user = params[:user]
      if user.present?
        query = {user_id: user.id}
        query[:status] = params[:status] if params[:status].present?
        data = Order.where(query).order('created_at desc').page(params[:page]).per(params[:limit])
        if Order.where({user_id: user.id}).count <= params[:page] * params[:limit]
          params[:last_page] = true
        end
        response_status.code = ResponseStatus::Code::SUCCESS
      end
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end
    return response_status, data
  end

  def self.get_charge_for_unpaid_order( params )
    response_status = ResponseStatus.default
    charge = nil
    begin
      transaction do
        raise RestError::MissParameterError if params[:order_id].blank?
        user = params[:user]
        if user.present?
          order = Order.where({user_id: user.id, id: params[:order_id], status: Order::Status::NOT_PAID}).first

          today = Time.now

          if order.created_at < today.beginning_of_day
            raise StandardError.new '订单已经过期'
          end

          if order.present? && order.charge_json.blank?
            charge = Pingpp::Charge.create(
                :order_no  => order.id,
                :app       => {id: Rails.application.config.pingpp_app_id},
                :channel   => order.pay_method,
                :amount    => (order.pay_price * 100).to_i,
                :client_ip => '127.0.0.1',
                :currency  => 'cny',
                :subject   => '早餐巴士',
                :body      => '开启全新一天'
            )
            order.charge_json = charge
            order.save!
            response_status.code = ResponseStatus::Code::SUCCESS
          elsif order.present? && order.charge_json.present?
            charge = order.charge_json
            response_status.code = ResponseStatus::Code::SUCCESS
          else
            response_status.message = '订单不存在或已经支付'
          end
        end
      end
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.o = ex.message
    end
    return response_status, charge
  end

  def self.create_new_order(params)
    response_status = ResponseStatus.default
    data = nil

    # #TODO 暂停内测
    # response_status.message = "寒假内测结束啦,下学期见~"
    # return response_status, data

    if (Time.now.hour + Time.now.min / 60.0) > (ServicesController.get_config[:deadline_hour] + ServicesController.get_config[:deadline_minute] / 60.0)
      response_status.message = "太迟啦,明天记得在#{ServicesController.get_config[:deadline_hour]}点#{ServicesController.get_config[:deadline_hour]}之前来哦"
      return response_status, data
    end

    begin
      self.transaction do
        raise StandardError.new '购物车是空的' if params[:cart_items].blank?
        raise RestError::MissParameterError if params[:campus].blank? || params[:cart_items].blank? || params[:pay_method].blank? || params[:delivery_time].blank? || params[:receiver_name].blank? || params[:receiver_phone].blank? || params[:receiver_address].blank?
        user = params[:user]
        cart_items = params[:cart_items]
        campus = params[:campus]
        coupon_id = params[:coupon_id] # 优惠券(可选)
        coupon = nil

        if coupon_id.present?
          coupon = Coupon.get_unused_activated_coupon_by_id_and_user(coupon_id, params[:user].id)
        end

        if user.present?
            total_price = 0.0
            pay_price = 0.0
            # 1.检测商店正常,商品和规格的状态正常并且规格stock > 0
            cart_items.each do | cart_item |
              # 注意cart_item是Hash类型
              product = Product.where(
                  {
                      id: cart_item[:product_id],
                  }).includes(:specifications)
                            .references(:specifications)
                            .where(
                                'specifications.id = ? and specifications.status = ?',
                                cart_item[:specification_id],
                                Specification::Status::Normal,
                            )
                            .first

              product_available = product.present?
              specification_available =  product.specifications.count > 0
              stock_available = product.specifications[0].stock >= cart_item[:quantity]
              product_valid = product.present? && product_available  && specification_available && stock_available
              if product_valid
                total_price += product.specifications[0].price * cart_item[:quantity]
              else
                raise StandardError.new('商品不存在') unless   product.present?
                raise StandardError.new('商品已下架') if  product.status != Product::Status::Normal
                raise StandardError.new('此规格不可用') unless   specification_available
                raise StandardError.new('购买数超过库存') unless   stock_available
              end
              if product.store.status != Store::Status::Normal
                raise StandardError.new('店铺已关闭')
              end
            end

            if coupon.present?
              # 判断优惠券是否达到最低消费额
              if total_price < coupon.least_price # 判断是否满足最低订单价
                raise StandardError.new("对不起,优惠券最低起用价格:#{coupon.least_price}")
              else #更新优惠券状态为已使用
                pay_price = total_price - coupon.discount
                  coupon.status = Coupon::Status::Used
                  coupon.save!
              end
            else
              pay_price = total_price
            end

            order = Order.new

            # 服务费用计算
            service_price = ServicesController.get_config[:service][:price] || 0.0

            order.pay_method = params[:pay_method]
            order.user = params[:user]
            # 总价
            order.price = total_price + service_price
            # 支付费用
            order.pay_price = pay_price + service_price
            # 服务费用
            order.service_price = service_price

            order.coupon = coupon
            order.campus_id = campus
            order.delivery_time = params[:delivery_time]
            order.receiver_name = params[:receiver_name]
            order.receiver_phone = params[:receiver_phone]
            order.receiver_address = params[:receiver_address]
            order.status = Order::Status::NOT_PAID

            order.save!
            # 创建Order_Item
            cart_items.each do | item |
              order_item = OrderItem.new
              order_item.product_id = item[:product_id]
              order_item.quantity = item[:quantity]
              order_item.order = order
              order_item.specification_id = item[:specification_id]
              order_item.price_snapshot = Specification.find(order_item.specification_id).price
              order_item.save!

            end
            response_status = ResponseStatus.default_success
            data = order
        end
      end
    rescue Exception => e
      Rails.logger.error(e.message)
      Rails.logger.error do
        ([e.message] + e.backtrace).join("\n")
      end unless e.blank?
      response_status.message = e.message
    end
    return response_status, data
  end

  # 更新用户订单
  #
  # @param options [Hash] 约束
  # @option options [Order] :order 订单数据
  # @option options [User] :user 关联用户
  #
  # @return [Array] response, coupon
  #
  def self.update_by_options(options = {})
    order = nil

    catch_proc = proc{ order = nil }

    response = ResponseStatus.__rescue__(catch_proc) do |res|

      user, order_id = options[:user], options[:order_id]

      # post 参数
      delivery_time, receiver_name, receiver_phone = options[:delivery_time], options[:receiver_name], options[:receiver_phone]

      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if user.blank? ||  order_id.blank?

      order = query_first_by_options(id: order_id, user: user)

      res.__raise__(ResponseStatus::Code::ERROR, '订单不存在') if order.blank?

      # 更新发货时间,收货人,收货电话
      order.delivery_time = delivery_time if delivery_time.present?
      order.receiver_name = receiver_name if receiver_name.present?
      order.receiver_phone = receiver_phone if receiver_phone.present?

      order.save!
    end

    return response, order
  end

  def check_order_status
    # 检查订单是否从未支付到支付
    if self.status_changed? && self.status_was == Order::Status::NOT_PAID && self.status == Order::Status::NOT_DELIVERED
      OrderPayDoneSmsWorker.perform_async(self.id)
    end
  end

  def check_order_fields
    unless PayMethod::ALL.include?(self.pay_method)
      errors.add(:pay_method, '不合法')
    end
  end

  def generate_order_number
    if self.order_number.blank?
      self.order_number = DateTime.now.strftime("%Y%m%d%H%M").to_s + (SecureRandom.random_number * 100000000000).to_i.to_s
    end
  end

  def check_coupon

  end

  #
  # 创建或者获取红包
  #
  def create_or_get_red_pack
    red_pack = nil

    catch_proc = proc { red_pack = nil }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      res.__raise__(ResponseStatus::Code::ERROR, '红包功能未开启') unless BasicConfigSetting.red_pack_available

      res.__raise__(ResponseStatus::Code::ERROR, '还没有红包可发') unless Status::PAYMENT_SUCCESS.include?(self.status)

      red_pack = self.red_pack

      if red_pack.blank?
        red_pack = RedPack.new
        red_pack.user = self.user
        red_pack.order = self
        red_pack.expired_at = self.payment.time_paid + BasicConfigSetting.red_pack_duration.to_i
        red_pack.save!
      end
    end

    return response, red_pack
  end

  #
  # 获取订单送餐时间格式化输出
  #
  def format_delivery_time
    time = self.created_at + 1.day
    "#{time.strftime("%Y年%m月%d日")}#{self.delivery_time}"
  end


end
