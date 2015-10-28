json.partial! 'api/status', response_status: @response_status
json.data do
  json.product do
    if @product.present?
      json.partial! @product, partial: 'products/product', as: :product
    else
      json.nil!
    end
  end
end