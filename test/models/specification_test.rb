# == Schema Information
#
# Table name: specifications
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null                  # 规格名称:颜色
#  value         :string(255)      not null                  # 规格值
#  price         :decimal(10, 2)   default("0.00"), not null # 商品单价
#  product_id    :integer          not null
#  status        :integer          default("1"), not null    # 规格状态
#  stock         :integer          default("0")              # 库存
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stock_per_day :integer          default("10"), not null   # 订单每日更新的库存
#

require 'test_helper'

class SpecificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
