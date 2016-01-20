class Expresses::Api::BaseController < ActionController::Base

  include Shared::Concerns::ApplicationControllerConcern

  before_filter :authorization_filter_for_expresses

  # 管理者不存在的错误
  class ExpresserNotFoundError < StandardError

  end

  def authorization_filter_for_expresses
    token = request.headers['x-access-token']

    message= nil
    begin
      if token.blank?
        message = '缺少token参数'
      else
        phone = nil

        begin
          result = JWT.decode(token, TsaoUtil[:secret], true, {algorithm: 'HS256'})
          phone = result[0]['express_phone']
        rescue Exception
          phone = nil
        end

        if phone.present?

          expresser = Expresser.query_first_by_options({phone: phone})
          if expresser.present?
            @expresser = expresser
            params[:expresser] = expresser
          else
            raise ExpresserNotFoundError
          end
        else
          raise ExpresserNotFoundError
        end
      end
    rescue ExpresserNotFoundError => err
      message = '没有权限'
    end

    if message.present?
      Rails.logger.error(message)

      render json: {status: ResponseStatus.need_login}, status: 200
    end

  end
end
