json.partial! 'api/status', response_status: @response_status

json.data do | json |
  json.stores do
    if @stores.present?
      json.array! @stores, partial: 'stores/store', as: :store
    else
      json.nil!
    end
  end
  json.products do
    if @products.present?
      json.array! @products, partial: 'products/product', as: :product
    else
      json.nil!
    end
  end
end