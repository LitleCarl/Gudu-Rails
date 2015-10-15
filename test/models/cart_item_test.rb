# == Schema Information
#
# Table name: cart_items
#
#  id               :integer          not null, primary key
#  quantity         :integer          default("1")
#  product_id       :integer          not null
#  specification_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class CartItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
