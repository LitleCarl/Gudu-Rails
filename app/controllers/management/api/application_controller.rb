class Management::Api::ApplicationController < ActionController::Base

  include Shared::Concerns::ApplicationControllerConcern

  before_filter :authorization_filter_for_management

  # 管理者不存在的错误
  class ManagerNotFoundError < StandardError

  end

  def authorization_filter_for_management
    token = request.headers['access-token']
    Rails.logger.error("access-token:#{token}")

    message= nil
    begin
      if token.blank?
        message = '缺少token参数'
      else
        phone = TsaoUtil.decode_jwt_user_session(token)
        if phone.present?
          puts "phone:#{phone}"
          manager = Manager.query_first_by_options({phone: phone})
          if manager.present?
            @manager = manager
            params[:manager] = @manager
          else
            raise ManagerNotFoundError
          end
        else
          raise ManagerNotFoundError
        end
      end
    rescue ManagerNotFoundError => err
      message = '没有权限'
    end
    if message.present?
      Rails.logger.error(message)

      render json: {status: ResponseStatus.need_login}, status: 200
    end

  end
end
