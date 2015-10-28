class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.string :name ,null: false, comment: '规格名称:颜色'
      t.string :value ,null: false, comment: '规格值'
      t.decimal :price, null: false, default: 0.00, precision: 10, scale: 2, comment: "商品单价"
      t.references :product, null: false
      t.integer :status, default: 1, null: false, comment: '规格状态'
      t.integer :stock, default: 0, comment: '库存'
      t.timestamps null: false
    end
  end
end
