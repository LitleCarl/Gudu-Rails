class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :payment_method, null: false
      t.datetime :time_paid, null: false
      t.decimal :amount, null: false, default: 0.00, precision: 10, scale: 2, comment: "支付总金额"
      t.string :transaction_no, null: false, comment: '交易号'
      t.string :charge_id, null: false, comment: 'charge id'
      t.references :orders, null: false, comment: '关联订单'
      t.timestamps null: false
    end
  end
end
