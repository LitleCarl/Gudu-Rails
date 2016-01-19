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

class CartItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :specification
end
