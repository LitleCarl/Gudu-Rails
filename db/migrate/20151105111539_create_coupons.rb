class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.decimal :discount, null: false, default: 0.00, precision: 10, scale: 2, comment: "抵扣金额"
      t.datetime :activated_date, null: false, comment: '生效日期'
      t.datetime :expired_date, null: false, comment: '失效日期'
      t.references :user, comment: '关联用户'
      t.integer :status, null: false, comment: '优惠券状态'
      t.decimal :least_price, null: false, default: 0.00, precision: 10, scale: 2, comment: "最低起用价"
      t.timestamps null: false
    end
  end
end
