class Management::Api::V1::ManagersController < Management::Api::ApplicationController

  # 跳过过滤器
  skip_before_action :authorization_filter_for_management, only: [:send_login_code, :login_with_sms_code]

  # 短信登陆
  def login_with_sms_code
    @response_status, @manager, @token = Manager.validate_login_with_sms_token(params)
  end

  # 发送登录短信
  def send_login_code
    @response_status, @token = Manager.send_sign_in_code(params)
  end

  # 自动登录
  def index
    @response_status = ResponseStatus.default_success
    @manager = params[:manager]
  end

end
