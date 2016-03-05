render_json_attrs(json, store, [:id, :name, :brief, :address, :logo_filename, :location, :pinyin, :status, :month_sale, :signature, :back_ratio, :main_food_list])

if store.owner.present?
  json.owner do
    json.partial! 'owners/owner', owner: store.owner
  end
else
  json.owner nil
end

json.categories do
  json.array! store.categories, partial: 'categories/category', as: :category
end

# has_many
json.products do
  json.array! store.products.where(status: Product::Status::Normal), partial: 'products/product', as: :product
end

# has_one
json.contract do
  if store.contract.present?
    json.partial! 'contracts/contract', contract: store.contract
  else
    json.nil!
  end
end

