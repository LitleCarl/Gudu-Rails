module ApplicationHelper

  # 返回图片、媒体等资源的完整 url
  # 仅在 controllers, helpers, views 范围内使用.
  #
  #
  # @param  path  [String, #read] 图片、媒体等 path.
  #
  # @return [String]
  def wrap_image_path_with_qiniu_site(relative_path)
    relative_path ||= ''
    images_site ||= 'http://7xnsaf.com1.z0.glb.clouddn.com'
    images_site + relative_path
  end
end
