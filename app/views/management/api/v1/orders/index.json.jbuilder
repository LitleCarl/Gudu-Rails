json.partial! 'api/status', response_status: @response_status

json.data do
  json.orders do
    json.array! @orders, partial: 'orders/order', as: :order
  end
  json.partial! 'api/paginator'
end