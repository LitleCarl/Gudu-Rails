json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @frozen_coupon.present?
    json.frozen_coupon do
      json.partial! @frozen_coupon, partial: 'frozen_coupons/frozen_coupon', as: :frozen_coupon
    end
  else
    json.frozen_coupon nil
  end
end