# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)                            # 分类名称
#  priority   :integer                                # 显示顺序(>=0)
#  store_id   :integer                                # 关联店铺
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联店铺
  belongs_to :store

  # 关联商品
  has_many :products


  # def self.import_from_products
  #   Store.all.each do |store|
  #     Store.transaction do
  #       categories = store.products.select(:category).distinct.map(&:category)
  #       categories.each do |category_name|
  #         category = Category.new
  #         category.store = store
  #         category.name = category_name
  #         category.priority = 0
  #         category.save!
  #         store.products.where('category = ?', category_name).update_all(category_id: category.id)
  #       end
  #
  #       puts "商铺:#{store.name}导入成功"
  #
  #     end
  #   end
  # end

end
