# == Schema Information
#
# Table name: product_images
#
#  id         :integer          not null, primary key
#  image_name :string(255)      not null
#  priority   :integer          default("0")
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductImage < ActiveRecord::Base
  belongs_to :product
end
