#encoding: utf-8

#
# 响应状态 ResponseStatus
#
# @note 响应状态 ResponseStatus
#
# @author blogbin <fengbin@atyun.net>
#
class ResponseStatus

  module Code

    ################################################################################
    #
    # 200 成功
    #
    ################################################################################

    SUCCESS = 200


    ################################################################################
    #
    # 5xx 系统相关
    #
    ################################################################################

    # 未知错误（通常在捕捉异常后使用）
    ERROR = 500

    ################################################################################
    #
    # 8xx 权限相关
    #
    ################################################################################

    # 需要登录
    NEED_LOGIN = 800

  end

  def self.get_messages(messages)

    message = ''

    messages.each do [name, values]

    if values.present?
      message = "#{message}\n#{values.join('\n')}"
    end

    end

    message.strip!
  end

  def self.convert_messages(messages, response_status)

    messages.each do |name, values|

      if values.present?
        response_status.message = "#{response_status.message}\n#{values.join('\n')}"
        response_status.message.strip!
      end

    end

    response_status
  end

  def self.convert_message(messages, name, response_status)
    values = messages[name]

    if values.present?
      response_status.message = "#{response_status.message}\n#{values.join('\n')}"
      response_status.message.strip!
    end

    response_status
  end

  #
  # 返回默认失败的 响应状态 ResponseStatus 的 json 数据
  #
  #
  # @note 返回默认失败的 响应状态 ResponseStatus
  #
  #
  # @example  返回默认失败的 响应状态 ResponseStatus
  #   ResponseStatus.default
  #
  #
  # @return [ResponseStatus]  返回默认失败的 响应状态 ResponseStatus
  #
  def self.default
    response_status = Hashie::Mash.new

    response_status.code = Code::ERROR
    response_status.message = ''
    # response_status.message = '未知错误'
    response_status.messages = []

    response_status
  end

  #
  # 返回默认成功的 响应状态 ResponseStatus
  #
  #
  # @note 返回默认成功的 响应状态 ResponseStatus
  #
  #
  # @example  返回默认成功的 响应状态 ResponseStatus
  #   ResponseStatus.default_success
  #
  #
  # @return [ResponseStatus]  返回默认成功的 响应状态 ResponseStatus
  #
  def self.default_success
    response_status = Hashie::Mash.new

    response_status.code = Code::SUCCESS

    response_status
  end

  #
  # 向 响应状态 ResponseStatus 追加 message
  #
  #
  # @note 向 响应状态 ResponseStatus 追加 message
  #
  #
  # @example  向 响应状态 ResponseStatus 追加 message
  #   ResponseStatus.append_message(response_status, '错误信息')
  #
  #
  # @param  response_status [ResponseStatus]  响应状态 @see ResponseStatus
  #
  # @param  message [String]  追加 message
  #
  #
  # @return [ResponseStatus, nil]  追加 message 后的响应状态 @see ResponseStatus
  #
  def self.append_message(response_status, message, delimiter = nil)
    delimiter ||= ';'

    response_status.message = (response_status.message.present? ? "#{response_status.message}#{delimiter}#{message}" : message)

    response_status
  end


  def self.need_login
    response_status = Hashie::Mash.new

    response_status.code = Code::NEED_LOGIN
    response_status.message = '请先登录'

    response_status
  end

  def self.no_data_found
    response_status = Hashie::Mash.new

    response_status.code = Code::ERROR
    response_status.message = '没有指定数据'

    response_status
  end
end