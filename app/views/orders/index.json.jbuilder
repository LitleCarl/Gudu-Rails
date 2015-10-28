json.partial! 'api/status', response_status: @response_status

json.data do | json |
  json.orders do | json |
    json.array! @orders, partial: 'orders/order', as: :order
  end
  json.partial! 'api/paginator'
end