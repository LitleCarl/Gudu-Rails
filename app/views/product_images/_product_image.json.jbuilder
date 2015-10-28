json.(product_image, :id, :priority, :product_id)

if product_image.present?
  json.image_name wrap_image_path_with_qiniu_site('/product_images/'+product_image.image_name)
else
  json.image_name nil
end
