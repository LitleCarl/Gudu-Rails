class UsersController < ApplicationController
  skip_before_filter :user_about, only: :login_with_sms_code
  def login_with_sms_code
    @response_status, @user, @token= User.validate_login_with_sms_token(params)
  end

  def index
    @response_status = ResponseStatus.default_success
    @user = params[:user]
  end
end
