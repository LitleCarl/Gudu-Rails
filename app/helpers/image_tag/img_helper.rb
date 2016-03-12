module ImageTag::ImgHelper

  module ImageStyle
    # 120*120
    Square_LOGO = 'store.list.logo'

    # APP 商铺logo缩略图
    STORE_LOGO = 'store.list.logo'

    # app商品缩略图
    PRODUCT_LOGO = 'store.list.logo'

    # app 产品详细大图
    PRODUCT_IMAGE_COMPRESS = 'product.image.compr'
  end

  #
  # 渲染img标签
  #
  # @param url [Unknown] json对象
  # @param style [ImageStyle] 七牛图片样式
  #
  def qiniu_img_tag(url, style, options = {})
    image_tag(build_img_url(url, style), options)
  end

  def build_img_url(image_base_url, style)
    "#{image_base_url}-#{style}"
  end
end
