# == Schema Information
#
# Table name: nutritions
#
#  id           :integer          not null, primary key
#  energy       :float(24)        default("0")          # 能量(千焦)
#  fat          :float(24)        default("0")          # 脂肪(克)
#  carbohydrate :float(24)        default("0")          # 碳水化合物(克)
#  sugar        :float(24)        default("0")          # 糖(克)
#  natrium      :float(24)        default("0")          # 盐(毫克)
#  product_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Nutrition < ActiveRecord::Base
  belongs_to :product
end
