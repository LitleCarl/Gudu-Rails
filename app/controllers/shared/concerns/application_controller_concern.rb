module Shared::Concerns::ApplicationControllerConcern
  extend ActiveSupport::Concern

  # 返回图片、媒体等资源的完整 url
  # 仅在 controllers, helpers, views 范围内使用.
  #
  # @example
  #   <% = image_tag wrap_image_path_with_site(get_product_image(product_image)) %>
  #
  # @example
  #   wrap_image_path_with_site('uploads/products/1/abc.jpg')
  #   # => 'http://cdn.example.com/uploads/products/1/abc.jpg'
  #
  # @param  path  [String, #read] 图片、媒体等 path.
  #
  # @return [String]
  def wrap_image_path_with_site(relative_path, path, images_site = nil)
    relative_path ||= ''
    images_site ||= @images_site

    images_site + '/' + relative_path + '/' + path
  end


  included do
    before_filter :add_default_paginator
  end
  def add_default_paginator
    params[:page] = 1 if params[:page].blank?
    params[:page] = params[:page].to_i
    params[:limit] = Kaminari.config.default_per_page if params[:limit].blank?
    params[:limit] = params[:limit].to_i
    params[:last_page] = false

  end
end
