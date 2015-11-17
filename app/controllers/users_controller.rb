class UsersController < ApplicationController
  skip_before_filter :user_about, only: [:login_with_sms_code, :bind_weixin]

  # 短信登陆
  def login_with_sms_code
    @response_status, @user, @token= User.validate_login_with_sms_token(params)
  end

  # 绑定微信账号
  def bind_weixin
    @response_status, @user, @token= User.bind_weixin(params)
  end

  def index
    @response_status = ResponseStatus.default_success
    @user = params[:user]
  end
end
