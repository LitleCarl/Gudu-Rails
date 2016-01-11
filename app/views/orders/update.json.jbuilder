json.partial! 'api/status', response_status: @response_status
json.data do
  json.order do
    if @order.present?
      json.partial! @order, partial: 'orders/order', as: :order
    else
      json.nil!
    end
  end
end