class CreateNutritions < ActiveRecord::Migration
  def change
    create_table :nutritions do |t|
      t.float :energy, default: 0, comment: '能量(千焦)'
      t.float :fat, default: 0, comment: '脂肪(克)'
      t.float :carbohydrate, default: 0, comment: '碳水化合物(克)'
      t.float :sugar, default: 0, comment: '糖(克)'
      t.float :natrium, default: 0, comment: '盐(毫克)'
      t.references :product
      t.timestamps null: false
    end
  end
end
