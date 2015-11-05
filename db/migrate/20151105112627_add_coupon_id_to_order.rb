class AddCouponIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :coupon_id, :integer, comment: '关联优惠券(如果使用了的话)'
    add_column :orders, :pay_price, :decimal, default: 0.00, precision: 10, scale: 2, comment: "实际支付金额"
  end
end
