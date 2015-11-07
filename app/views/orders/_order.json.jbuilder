json.(order, :id, :status, :price, :delivery_time, :receiver_name, :receiver_phone, :receiver_address, :pay_method, :order_number, :pay_price)
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
json.user_id order.user_id
