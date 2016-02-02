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

  def jv
    'javascript:void(0);'
  end

  def action_index?
    @action_new_result ||= action_name == 'index'
  end

  def action_new?
    @action_new_result ||= action_name == 'new'
  end

  def action_show?
    @action_show_result ||= action_name == 'show'
  end

  def action_edit?
    @action_edit_result ||= action_name == 'edit'
  end

  # 重载image_tag
  def image_tag(source, options = {})
    super source, options.merge(alt: '')
  end

end
