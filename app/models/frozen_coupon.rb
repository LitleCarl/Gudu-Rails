# == Schema Information
#
# Table name: frozen_coupons
#
#  id               :integer          not null, primary key
#  authorization_id :integer
#  discount         :decimal(10, 2)   default("0.00"), not null
#  activated_date   :datetime         not null
#  expired_date     :datetime         not null
#  least_price      :decimal(10, 2)   default("0.00"), not null
#  coupon_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  red_pack_id      :integer
#

class FrozenCoupon < ActiveRecord::Base

  belongs_to :red_pack

  # 关联优惠券
  belongs_to :coupon

  # 关联第三方登录
  belongs_to :authorization

  # 给Authorization用户发红包
  #
  # @param options [Hash] 约束
  # @option options [Authorization] :authorization 授权账号
  # @option options [Decimal] :discount 抵用
  # @option options [Decimal] :least_price 最低消费
  # @option options [Datetime] :activated_date 生效时间
  # @option options [Datetime] :expired_date 过期时间
  #
  # @return [Array] 相应, 预留红包
  #
  def self.generate_frozen_coupon(options)

    frozen_coupon = nil
    catch_proc = proc{ frozen_coupon = nil }
    red_pack, authorization, discount, least_price, activated_date, expired_date = options[:red_pack], options[:authorization], options[:discount], options[:least_price], options[:activated_date] || Time.now, options[:expired_date] || (Time.now + 7.days)
    response = ResponseStatus.__rescue__(catch_proc) do |res|

      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if red_pack.blank? || authorization.blank? || discount.blank? || least_price.blank? || activated_date.blank? || expired_date.blank?

      frozen_coupon = FrozenCoupon.new
      frozen_coupon.authorization = authorization
      frozen_coupon.discount = discount
      frozen_coupon.activated_date = activated_date
      frozen_coupon.expired_date = expired_date
      frozen_coupon.least_price = least_price
      frozen_coupon.red_pack = red_pack

      # 如果微信用户已经绑定User,则直接派发红包
      if authorization.user.present?
        response, coupon = Coupon.generate_coupon({
                                            user: authorization.user,
                                            discount: discount,
                                            activated_date: activated_date,
                                            expired_date: expired_date,
                                            least_price: least_price
                                        })
        frozen_coupon.coupon = coupon
      end

      frozen_coupon.save!

    end

    return response, frozen_coupon

  end

end
