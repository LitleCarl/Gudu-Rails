class AddFrozenCouponBelongsToRedPack < ActiveRecord::Migration
  def change
    add_column :frozen_coupons, :red_pack_id, :integer, comment: '暂存优惠券属于某个红包'
  end
end
