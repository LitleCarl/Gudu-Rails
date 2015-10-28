class CreateSubOrders < ActiveRecord::Migration
  def change
    create_table :sub_orders do |t|
      t.references :owner, null: false, comment: '所属商家'
      t.references :orders, null: false, comment: '所属父订单'
      t.decimal :price, null: false, default: 0.00, precision: 10, scale: 2, comment: "子订单总价"
      t.datetime :origin_date ,null: false, comment: '父订单创建时间'
      t.timestamps null: false
    end
  end
end
