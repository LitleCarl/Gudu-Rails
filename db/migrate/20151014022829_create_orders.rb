class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :status, default: 1, null: false
      t.decimal :price, null: false, default: 0.00, precision: 10, scale: 2, comment: "总金额"
      t.string :delivery_time, null: false
      t.string :receiver_name, null: false
      t.string :receiver_phone, null: false
      t.string :receiver_address, null: false
      t.references :campuses
      t.references :user
      t.string :pay_method, null: false

      t.timestamps null: false
    end
  end
end
