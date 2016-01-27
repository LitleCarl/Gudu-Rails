class Management::ManagementBaseController < ActionController::Base

  include Shared::Concerns::ApplicationControllerConcern

  layout 'management'

  before_filter :authenticate_management_manager!

  before_filter :set_manager_in_params

  # 在请求参数中加入manager
  def set_manager_in_params
    params[:manager] = current_management_manager
  end

  def is_management_controller?
    true
  end

end
