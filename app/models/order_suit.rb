# == Schema Information
#
# Table name: order_suits
#
#  id             :integer          not null, primary key
#  quantity       :integer                                    # 数量
#  price_snapshot :decimal(10, 2)   default("0.00"), not null # 价格快照
#  order_id       :integer                                    # 关联订单
#  suit_id        :integer                                    # 关联套餐
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class OrderSuit < ActiveRecord::Base
  # 通用查询方法
  include Concerns::Query::Methods

  # 关联套餐
  belongs_to :suit

  # 关联订单
  belongs_to :order
end
