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
#  pay_price        :decimal(10, 2)   default("0.00")
#

class Order < ActiveRecord::Base
  belongs_to :campus
  belongs_to :user
  has_one :payment
  has_many :order_items
  has_one :coupon

  before_create :generate_order_number
  validate :check_order_fields
  after_save :check_order_status
  after_create :check_coupon

  module Status
    Dead = 0          # 取消的订单
    Not_Paid = 1      # 未支付
    Not_Delivered = 2 # 未发货
    Not_Received = 3  # 未收到
    Not_Commented = 4 # 未评论
    Done = 5          # 完成
  end

  module PayMethod
    WEIXIN = 'wx'
    ALIPAY = 'alipay'
    ALL = [WEIXIN, ALIPAY]
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
      raise RestError::MissParameterError if params[:order_id].blank?
      user = params[:user]
      if user.present?
        order = Order.where({user_id: user.id, id: params[:order_id], status: Order::Status::Not_Paid}).first
        if order.present? && order.charge_json.blank?
          charge = Pingpp::Charge.create(
              :order_no  => order.id,
              :app       => {id: Rails.application.config.pingpp_app_id},
              :channel   => order.pay_method,
              :amount    => (order.pay_price * 100).to_i,
              :client_ip => '127.0.0.1',
              :currency  => 'cny',
              :subject   => '咕嘟早餐',
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
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end
    return response_status, charge
  end


  def self.create_new_order(params)
    response_status = ResponseStatus.default
    data = nil
    begin
      self.transaction do
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

            order.pay_method = params[:pay_method]
            order.user = params[:user]
            order.price = total_price
            order.pay_price = pay_price
            order.coupon = coupon
            order.campus_id = campus
            order.delivery_time = params[:delivery_time]
            order.receiver_name = params[:receiver_name]
            order.receiver_phone = params[:receiver_phone]
            order.receiver_address = params[:receiver_address]
            order.status = Order::Status::Not_Paid

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

  def check_order_status
    # 检查订单是否从未支付到支付
    if self.status_changed? && self.status_was == Order::Status::Not_Paid && self.status == Order::Status::Not_Delivered
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

end
