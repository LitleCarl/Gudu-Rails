json.(product, :id, :store_id, :name, :logo_filename, :brief, :min_price, :max_price, :category, :status, :pinyin)
json.specifications do | json |
  json.array! product.specifications, partial: 'specifications/specification', as: :specification
end