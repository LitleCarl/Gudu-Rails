json.(store, :id, :name, :brief, :address, :logo_filename, :location, :pinyin, :status)
if store.logo_filename.present?
  json.logo_filename wrap_image_path_with_qiniu_site('/stores/'+store.logo_filename)
else
  json.logo_filename nil
end
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

