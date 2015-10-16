json.(order, :id, :status, :price, :delivery_time, :receiver_name, :receiver_phone, :receiver_address, :pay_method)
json.order_items do | json |
  json.array! order.order_items, partial: 'order_items/order_item', as: :order_item
end
json.payment do
  json.partial! 'payments/payment', payment: order.payment
end
#belongs_to
json.campus_id order.campus_id
json.user_id order.user_id
