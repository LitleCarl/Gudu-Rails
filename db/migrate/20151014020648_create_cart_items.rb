class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :quantity, default: 1, comment: '数量'
      t.references :product, null: false, comment: '关联商品'
      t.references :specification, null: false, comment: '关联规格'
      t.timestamps null: false
    end
  end
end
