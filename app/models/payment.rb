# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  payment_method :string(255)      not null
#  time_paid      :datetime         not null
#  amount         :decimal(10, 2)   default("0.00"), not null
#  transaction_no :string(255)      not null
#  charge_id      :string(255)      not null
#  order_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pingpp_info    :string(255)
#
class Payment < ActiveRecord::Base
  belongs_to :order
  after_create :set_order_paid_and_update_product_specification
  validate :check_field_ok


  # 检查字段合法
  def check_field_ok
    unless Order::PayMethod::ALL.include?(self.payment_method)
      errors.add(:payment_method, '不合法')
    end
  end

  # 创建Payment后关联订单
  def set_order_paid_and_update_product_specification
    if self.order.status == Order::Status::Not_Paid
      self.order.status = Order::Status::Not_Delivered
      self.order.save
      Rails.logger.debug '第三方支付回调并且关联订单成功'
      # 开始更新商品状态
      self.order.order_items.each do | order_item |
        order_item.specification.stock -= order_item.quantity
        order_item.specification.save
      end
    end
  end
end
