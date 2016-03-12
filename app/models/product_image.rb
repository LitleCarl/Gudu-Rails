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

  # 关联商品
  belongs_to :product

  # 商铺logo挂载
  mount_uploader :image_name, ImageUploader
end
