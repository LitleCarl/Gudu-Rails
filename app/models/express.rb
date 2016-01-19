# == Schema Information
#
# Table name: expresses
#
#  id           :integer          not null, primary key
#  expresser_id :integer                                # 快递员
#  order_id     :integer                                # 关联订单
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Express < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联送餐员
  has_one :expresser

  # 关联订单
  has_one :order
end
