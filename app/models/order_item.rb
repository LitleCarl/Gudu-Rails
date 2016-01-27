# == Schema Information
#
# Table name: order_items
#
#  id               :integer          not null, primary key
#  quantity         :integer          default("1"), not null
#  price_snapshot   :decimal(10, 2)   default("0.00"), not null
#  product_id       :integer          not null
#  order_id         :integer          not null
#  specification_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class OrderItem < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 数组助手
  include ActionView::Helpers::NumberHelper

  # 关联商品
  belongs_to :product

  # 关联订单
  belongs_to :order

  # 关联规格
  belongs_to :specification

  #
  # 格式化输出订单在此OrderItem上花了多少钱
  #
  def quantity_multiply_price_snapshot
    "#{number_to_currency(quantity * price_snapshot, unit: '¥')}元"
  end

end
