json.(frozen_coupon, :id, :activated_date, :least_price, :discount)
json.expired_date "还剩:#{((frozen_coupon.expired_date - Time.now)/(24*60*60)).round.to_s}天"
