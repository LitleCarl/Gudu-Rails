module Shared::Concerns::ApplicationControllerConcern
  extend ActiveSupport::Concern



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
