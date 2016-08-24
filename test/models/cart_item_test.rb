# == Schema Information
#
# Table name: cart_items
#
#  id               :integer          not null, primary key
#  quantity         :integer          default("1")          # 数量
#  product_id       :integer          not null              # 关联商品
#  specification_id :integer          not null              # 关联规格
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class CartItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
