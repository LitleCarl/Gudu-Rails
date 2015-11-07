class FixCouponAndOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :coupon_id, comment: '删除订单和优惠券关联'
    add_column :coupons, :order_id, :integer, comment: '订单关联coupon'
  end
end
