class Management::ManagementBaseController < ActionController::Base

  include Shared::Concerns::ApplicationControllerConcern

  layout 'management'

  before_filter :authenticate_management_manager!

  before_filter :set_manager_in_params

  # before_render :detect_response_from_model_method

  # 在请求参数中加入manager
  def set_manager_in_params
    params[:manager] = current_management_manager
  end

  def is_management_controller?
    true
  end

  # 检查是否存在@response的message
  def render *args
    @response ||= nil
    if @response.present? && @response.message.present?
      flash[:alert] = @response.message
      Rails.logger.debug("----------@response报错:#{@response.message}")
      # 如果有重写返回地址,则直接跳转,不渲染了
      if self.respond_to?(:redirect_url_if_error)
        return  redirect_to self.redirect_url_if_error, flash: {alert: @response.message}
      else
        return  redirect_to request.referrer, flash: {alert: @response.message}
      end
    end
    super
  end

end
