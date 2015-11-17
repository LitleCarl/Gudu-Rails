# == Schema Information
#
# Table name: sub_orders
#
#  id          :integer          not null, primary key
#  owner_id    :integer          not null                  # 所属商家
#  order_id    :integer          not null
#  price       :decimal(10, 2)   default("0.00"), not null # 子订单总价
#  origin_date :datetime         not null                  # 父订单创建时间
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SubOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :owner
end
