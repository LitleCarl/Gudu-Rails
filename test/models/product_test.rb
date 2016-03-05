# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  store_id      :integer          not null
#  name          :string(255)      not null
#  logo_filename :string(255)      not null
#  brief         :string(255)      default("暂无简介")
#  min_price     :string(255)      default("0.0")
#  max_price     :string(255)      default("0.0")
#  category      :string(255)      not null
#  status        :integer          default("1"), not null
#  pinyin        :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  month_sale    :integer          default("23")
#  category_id   :integer                                 # 关联分类
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
