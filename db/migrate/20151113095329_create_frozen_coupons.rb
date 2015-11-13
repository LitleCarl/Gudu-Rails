class CreateFrozenCoupons < ActiveRecord::Migration
  def change
    create_table :frozen_coupons do |t|

      t.belongs_to :authorization, comment: '关联第三方登录(微信)'
      t.decimal :discount, null: false, default: 0.00, precision: 10, scale: 2, comment: "抵扣金额"
      t.datetime :activated_date, null: false, comment: '生效日期'
      t.datetime :expired_date, null: false, comment: '失效日期'
      t.decimal :least_price, null: false, default: 0.00, precision: 10, scale: 2, comment: "最低起用价"
      t.belongs_to :coupon, comment: '关联优惠券'
      t.timestamps null: false
    end
  end
end
