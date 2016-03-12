class RemoveCategoryFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :category, comment: '不再支持category字段'
  end
end
