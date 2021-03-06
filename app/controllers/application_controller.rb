class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  layout 'management' if :devise_controller?

  before_filter :user_about, unless: (:devise_controller? || :is_management_controller?)

  include Shared::Concerns::ApplicationControllerConcern

  # 用户不存在的错误
  class UserNotFoundError < StandardError

  end

  # 是微信浏览器
  def weixin_browser?
    RequestBrowser.weixin_browser?(request)
  end

  def qq_browser?
    RequestBrowser.qq_browser?(request)
  end

  # 是安卓
  def is_android_device?
    RequestBrowser.is_android?(request)
  end

  # 是iOS
  def is_iphone_device?
    RequestBrowser.is_iphone?(request)
  end


  def user_about
    token = request.headers['x-access-token']
    Rails.logger.error('headers' + token) if token.present?

    message= nil
    begin
      if token.blank?
        message = '缺少token参数'
      else
        phone = TsaoUtil.decode_jwt_user_session(token)
        if phone.present?
          user = User.where({phone: phone}).first
          if user.present?
            @user = user
            params[:user] = @user
          else
            raise UserNotFoundError
          end
        else
          raise UserNotFoundError
        end
      end
    rescue UserNotFoundError => err
      message = '没有权限'
    end
    if message.present?
      Rails.logger.error(message)

      render json: {status: ResponseStatus.need_login}, status: 200
    end

  end
end
