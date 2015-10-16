require 'TsaoUtil'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_filter :user_about

  include Shared::Concerns::ApplicationControllerConcern

  # 用户不存在的错误
  class UserNotFoundError < StandardError

  end
  @images_site = 'http://gudu-sails.tunnel.mobi/'
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
