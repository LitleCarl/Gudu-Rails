json.partial! 'api/status', response_status: @response_status

json.data do | json |
  json.coupons do | json |
    json.array! @coupons, partial: 'coupons/coupon', as: :coupon
  end
  json.partial! 'api/paginator'
end