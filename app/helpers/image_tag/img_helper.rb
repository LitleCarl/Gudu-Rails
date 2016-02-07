module ImageTag::ImgHelper

  module ImageStyle
    # 120*120
    Square_LOGO = 'square.logo'

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
