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
#

class Order < ActiveRecord::Base
  belongs_to :campus
  belongs_to :user
  has_one :payment
  has_many :order_items
  validates :check_order_fields
  module Status
    Dead = 0          # 取消的订单
    Not_Paid = 1      # 未支付
    Not_Delivered = 2 # 未发货
    Not_Received = 3  # 未收到
    Not_Commented = 4 # 未评论
    Done = 5          # 完成
  end

  module PayMethod
    WEIXIN = 'WX'
    ALIPAY = 'alipay'
    ALL = [WEIXIN, ALIPAY]
  end

  def self.get_orders_of_user( params )
    response_status = ResponseStatus.default
    data = nil
    begin
      #raise RestError::MissParameterError if params[:user].blank?
      user = params[:user]
      if user.present?
        data = Order.where({user_id: user.id}).order('created_at desc').page(params[:page]).per(params[:limit])
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
        order = Order.where({user_id: user.id, status: Order.Status::Not_Paid}).first
        if order.present?
          charge = Pingpp::Charge.create(
              :order_no  => order.id,
              :app       => {id: 'app_Kmv5a5z1aLy5Tavn'},
              :channel   => order.pay_method,
              :amount    => order.price * 100,
              :client_ip => '127.0.0.1',
              :currency  => 'cny',
              :subject   => '咕嘟早餐',
              :body      => '开启全新一天'
          )
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
        if user.present?
          total_price = 0.0
          # 1.检测商店正常,商品和规格的状态正常并且规格stock > 0
          cart_items.each do | cart_item |
            # 注意cart_item是Hash类型
            product = Product.includes(:specifications)
                          .references(:specifications)
                          .where(
                              {product_id: cart_item[:product_id],
                               status: Product.Status::Normal,
                               specifications: {id: cart_item[:specification_id],
                                                status: Specification.Status::Normal,
                                                stock: (cart_item[:quantity]..Float::INFINITY)
                               }
                              }
                          )
                          .first

            product_valid = product.present? && product.specifications.count > 0
            if product_valid
              total_price += product.specifications[0].price * cart_item[:quantity]
            end
            unless product_valid
              raise StandardError.new('商品不可购买')
            end
            if product.store.status != Store.Status::Normal
              raise StandardError.new('店铺已关闭')
            end
          end
          order = Order.new(
              {
              pay_method: params[:pay_method],
              user: params[:user],
              price: total_price,
              campus: params[:campus],
              delivery_time: params[:delivery_time],
              receiver_name: params[:receiver_name],
              receiver_phone: params[:receiver_phone],
              receiver_address: params[:receiver_address]
            }
          )
          order.save!
          # 创建Order_Item
          cart_items.each do | item |
            cart_item = CartItem.new
            cart_item.product_id = item[:product_id]
            cart_item.quantity = item[:quantity]
            cart_item.order = order
            cart_item.specification_id = item[:specification_id]
            cart_item.price_snapshot = Specification.find(cart_item.specification_id).price
            cart_item.save!
          end
          response_status = ResponseStatus.default_success
        end
      end
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end
    return response_status, data
  end


  def check_order_fields
    unless PayMethod.include?(self.pay_method)
      errors.add(:pay_method, '不合法')
    end
  end
end
