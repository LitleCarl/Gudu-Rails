class CouponsController < ApplicationController
  skip_before_filter :user_about

  # /users/:user_id/coupons
  # 获取用户的优惠券
  def index
    @response_status, @coupons = Coupon.get_coupons_for_user_for_api(params)
  end
end
