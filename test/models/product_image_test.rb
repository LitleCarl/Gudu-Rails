# == Schema Information
#
# Table name: product_images
#
#  id         :integer          not null, primary key
#  image_name :string(255)      not null              # 图片名
#  priority   :integer          default("0")          # 图片优先级
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ProductImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
