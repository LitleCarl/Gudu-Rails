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
#  order_id       :integer
#

class Coupon < ActiveRecord::Base
  belongs_to :user
  belongs_to :order

  module Status
    Unused = 1
    Used = 2
  end

  #####################################################################################
  #
  #
  #
  #   类方法定义
  #
  #
  #
  #####################################################################################

  # 给用户发优惠券
  #
  # @param options [Hash] 约束
  # @option options [Decimal] :discount 抵用
  # @option options [Decimal] :least_price 最低消费
  # @option options [Datetime] :activated_date 生效时间
  # @option options [Datetime] :expired_date 过期时间
  # @option options [User] :user 关联用户
  #
  # @return [Array] response, coupon
  #
  def self.generate_coupon(options)

    coupon = nil
    catch_proc = proc{ coupon = nil }

    user, discount, least_price, activated_date, expired_date = options[:user], options[:discount], options[:least_price], options[:activated_date] || Time.now, options[:expired_date] || (Time.now + 7.days)
    response = ResponseStatus.__rescue__(catch_proc) do |res|

      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if user.blank? || discount.blank? || least_price.blank? || activated_date.blank? || expired_date.blank?

      coupon = Coupon.new
      coupon.status = Status::Unused
      coupon.discount = discount
      coupon.activated_date = activated_date
      coupon.expired_date = expired_date
      coupon.least_price = least_price
      coupon.user = user
      coupon.save!
    end

    return response, coupon
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
    return self.where(id: coupon_id, user_id: user_id, status: Coupon::Status::Unused).where('activated_date <= ?', Time.now).where('expired_date >= ?', Time.now).first
  end

  #
  # (API)获取指定用户的优惠券
  #
  # @param params [Hash] 参数
  # @option params [String] user_id 关联用户
  #
  # @return coupons [Array] 返回优惠券数组
  #
  def self.get_coupons_for_user_for_api(params)
    coupons = nil
    response = ResponseStatus.__rescue__ do |res|
       res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if params[:user].blank?
        coupons = Coupon.where(user_id: params[:user_id], status: Coupon::Status::Unused).where('activated_date <= ?', Time.now).where('expired_date >= ?', Time.now)
    end
    return response, coupons
  end
end
