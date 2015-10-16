class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :quantity, null: false, default: 1, comment: '数量'
      t.decimal :price_snapshot, null: false, default: 0.00, precision: 10, scale: 2, comment: "单价快照"
      t.references :product, null: false
      t.references :orders, null: false
      t.references :specification, null: false
      t.timestamps null: false
    end
  end
end
