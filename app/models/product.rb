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
#

class Product < ActiveRecord::Base
  belongs_to :store
  has_one :nutrition
  has_many :specifications
  has_many :product_images

  # 拼音
  before_save :set_pinyin

  module Status
    Normal = 1  # 上架
    Pending = 2 # 下架
  end

  # 设置拼音
  def set_pinyin
    if self.changed.include?('name')
      self.pinyin = HanziToPinyin.hanzi_to_pinyin(self.name).upcase
    end

  end
end
