class CreateOrderSuits < ActiveRecord::Migration
  def change
    create_table :order_suits do |t|
      t.integer :quantity, comment: '数量'
      t.decimal :price_snapshot, null: false, default: 0.00, precision: 10, scale: 2, comment: '价格快照'
      t.references :order, comment: '关联订单'
      t.references :suit, comment: '关联套餐'
      t.timestamps null: false
    end
  end
end
