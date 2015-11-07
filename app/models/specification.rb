# == Schema Information
#
# Table name: specifications
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  value         :string(255)      not null
#  price         :decimal(10, 2)   default("0.00"), not null
#  product_id    :integer          not null
#  status        :integer          default("1"), not null
#  stock         :integer          default("0")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stock_per_day :integer          default("10"), not null
#

class Specification < ActiveRecord::Base
  belongs_to :product
  before_save :ensure_stock_not_negative
  after_save :update_product_min_max_price
  module Status
    Normal = 1  # 上架
    Pending = 2 # 下架
  end

  # 规格更新每日库存
  def self.update_daily_stock
    Specification.all.each do | specification |
      specification.stock = specification.stock_per_day
      specification.save
    end
  end

  # 确保库存非负
  def ensure_stock_not_negative

    # 确保库存非负
    if self.stock < 0
      self.stock = 0
    end
  end

  def update_product_min_max_price
    # 更新商品最高最低价格
    if self.changed.include?('price')
    max_price = Specification.where({product_id: self.product.id}).maximum(:price)
    min_price = Specification.where({product_id: self.product.id}).minimum(:price)
    self.product.max_price = max_price
    self.product.min_price = min_price
    self.product.save
    end
  end
end
