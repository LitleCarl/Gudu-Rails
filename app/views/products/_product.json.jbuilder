render_json_attrs(json, product, [:id, :store_id, :name, :logo_filename, :brief, :min_price, :max_price, :status, :pinyin, :month_sale])

# 兼容旧版本APP category字段
json.category product.category_name

json.specifications do | json |
  json.array! product.specifications.where(status: Specification::Status::Normal), partial: 'specifications/specification', as: :specification
end
json.product_images do | json |
  json.array! product.product_images, partial: 'product_images/product_image', as: :product_image
end
# if product.logo_filename.present?
#   json.logo_filename wrap_image_path_with_qiniu_site('/products/' + product.logo_filename)
# else
#   json.logo_filename nil
# end

if product.nutrition.present?
  json.nutrition product.nutrition
else
  json.nutrition nil
end

if product.logo_filename.blank?
  json.logo_filename 'http://7xnsaf.com1.z0.glb.clouddn.com/avatar.jpg'
end
