render_json_attrs(json, order, [:id, :status, :price, :delivery_time, :receiver_name, :receiver_phone, :receiver_address, :pay_method, :order_number, :pay_price, :print_count])

json.status_desc Order::Status.get_desc_by_value(order.status)

json.order_items do | json |
  if order.order_items.present?
    json.array! order.order_items, partial: 'order_items/order_item', as: :order_item
  else
    json.nil!
  end
end
json.payment do
  if order.payment.present?
    json.partial! 'payments/payment', payment: order.payment
  else
    json.nil!
  end
end
#belongs_to
json.campus_id order.campus_id
json.campus do
  json.partial! 'campuses/campus', campus: order.campus
end

# 送餐员
json.expresser do
  if order.expresser
    json.partial! 'expressers/expresser', expresser: order.expresser
  else
    json.nil!
  end
end

json.user_id order.user_id


