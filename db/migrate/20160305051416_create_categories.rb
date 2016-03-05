class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, comment: '分类名称'
      t.integer :priority, comment: '显示顺序(>=0)'
      t.references :store, comment: '关联店铺'
      t.timestamps null: false
    end
  end
end
