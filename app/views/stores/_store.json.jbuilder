json.(store, :id, :name, :brief, :address, :logo_filename, :location, :pinyin, :status)
json.logo_filename asset_url('stores/'+store.logo_filename)
# has_many
json.products do
  json.array! store.products, partial: 'products/product', as: :product
end

# has_one
json.contract do
  if store.contract.present?
    json.partial! 'contracts/contract', contract: store.contract
  else
    json.nil!
  end
end

