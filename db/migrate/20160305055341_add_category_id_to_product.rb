class AddCategoryIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :category_id, :integer, comment: '关联分类'
  end
end
