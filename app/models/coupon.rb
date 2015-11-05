# == Schema Information
#
# Table name: coupons
#
#  id             :integer          not null, primary key
#  discount       :decimal(10, 2)   default("0.00"), not null
#  activated_date :datetime         not null
#  expired_date   :datetime         not null
#  user_id        :integer
#  status         :integer          not null
#  least_price    :decimal(10, 2)   default("0.00"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Coupon < ActiveRecord::Base
  belongs_to :user

  module Status
    Unused = 1
    Used = 2
  end

  #
  # 获取没使用的正在有效期内的制定用户下的指定优惠券
  #
  # @param coupon_id [Integer] 优惠券id
  # @param user_id [Integer] 用户id
  #
  # @return coupon [Coupon] 返回制定优惠券
  #
  def self.get_unused_activated_coupon_by_id_and_user(coupon_id, user_id)
    return Coupon.where(id: coupon_id, user_id: user_id, status: Coupon::Status::Unused).where('activated_date <= ?', Time.now).where('expired_date >= ?', Time.now).first
  end

end
