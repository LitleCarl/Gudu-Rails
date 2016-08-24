# == Schema Information
#
# Table name: specifications
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null                  # 规格名称:颜色
#  value         :string(255)      not null                  # 规格值
#  price         :decimal(10, 2)   default("0.00"), not null # 商品单价
#  product_id    :integer          not null
#  status        :integer          default("1"), not null    # 规格状态
#  stock         :integer          default("0")              # 库存
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stock_per_day :integer          default("10"), not null   # 订单每日更新的库存
#  cost          :decimal(10, 2)   default("0.00")           # 成本价
#

class Specification < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联商品
  belongs_to :product

  has_many :order_items

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

  # 创建新规格
  #
  # @param options [Hash]
  # @option options [Product] :product 商品
  # @option options [String] :specification_name 规格名称
  # @option options [String] :specification_value 规格值
  # @option options [String/Float] :price 价格
  # @option options [String/Float] :cost 成本价
  # @option options [Integer] :stock 库存
  #
  # @return [Array] response, specification
  #
  def self.create_with_options(options={})
    specification = nil

    catch_proc = proc {specification = nil}
    response = ResponseStatus.__rescue__(catch_proc) do |res|
      product, specification_name, specification_value, price, cost, stock = options[:product], options[:specification_name], options[:specification_value], options[:price], options[:cost], options[:stock]
      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if product.blank? || specification_name.blank? || specification_value.blank? || price.blank?

      specification = Specification.new
      specification.name = specification_name
      specification.value = specification_value
      specification.price = price
      specification.cost = cost || price
      specification.stock = stock || 500
      specification.product = product

      specification.save!
    end

    return response, specification
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
