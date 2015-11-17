# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  store_id      :integer          not null
#  name          :string(255)      not null               # 商品名
#  logo_filename :string(255)      not null               # 商品logo缩略图
#  brief         :string(255)      default("暂无简介")        # 商品简介
#  min_price     :string(255)      default("0.0")         # 规格中最低价
#  max_price     :string(255)      default("0.0")         # 规格中最高价
#  category      :string(255)      not null               # 商品分类,"饮料"
#  status        :integer          default("1"), not null
#  pinyin        :string(255)                             # 拼音
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  month_sale    :integer          default("23")          # 月售
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
