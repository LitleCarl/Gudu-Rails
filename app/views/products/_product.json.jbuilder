json.(product, :id, :store_id, :name, :logo_filename, :brief, :min_price, :max_price, :category, :status, :pinyin)
json.specifications do | json |
  json.array! product.specifications, partial: 'specifications/specification', as: :specification
end
json.product_images do | json |
  json.array! product.product_images, partial: 'product_images/product_image', as: :product_image
end
json.logo_filename asset_url('products/' + product.logo_filename)#wrap_image_path_with_site(product.logo_filename, )