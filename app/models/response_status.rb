#encoding: utf-8

#
# 响应状态 ResponseStatus
#
# @note 响应状态 ResponseStatus
#
# @author blogbin <fengbin@atyun.net>
#
class ResponseStatus
# 添加属性
  attr_accessor :code, :message, :messages

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

    # 缺少参数
    MISS_PARAM = 501

  end

  def initialize(code = Code::SUCCESS, message = '', messages = [])
    @code = code
    @message = message
    @messages = messages
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
    response_status = self.new

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
    response_status = self.new

    response_status.code = Code::SUCCESS

    response_status
  end

  def self.default_access_limit
    response_status = self.new

    response_status.code = Code::ERROR
    response_status.message = '稍后再试'

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
    response_status = self.new

    response_status.code = Code::NEED_LOGIN
    response_status.message = '请先登录'

    response_status
  end

  def self.no_data_found
    response_status = self.new

    response_status.code = Code::ERROR
    response_status.message = '没有指定数据'

    response_status
  end

  def self.merge_status(status_one, status_two)
    response_status = status_one
    if status_one.code == Code::SUCCESS && status_two.code == Code::SUCCESS
      response_status.code = ResponseStatus::Code::SUCCESS
    else
      response_status.code = status_two.code if status_two.code != Code::SUCCESS
      response_status.message = "#{status_one.message},#{status_two.message}"
    end
    response_status
  end

  #
  # 接口请求方法
  #
  # @example 订单确认收货
  #
  #  response = ResponseStatus.__rescue__ do |res|
  #     order = Order.where(xxx: 'xxx').first
  #
  #     res.__raise__(Response::Code::ERROR, '订单未找到') if order.blank?
  #
  #     order.status = Order::Status::Completed
  #
  #     order.save!
  #  end
  #
  # @return [Response] 返回对象
  #
  def self.__rescue__(catch_proc = nil)
    response = self.new
    begin
      yield(response)
    rescue Exception => e
      puts e.backtrace
      # 执行catch块
      catch_proc.call if catch_proc.present?

      # 如果是非开发者自己抛出的异常
      if response.code == Code::SUCCESS
        response.code = Code::ERROR
        response.message = e.message
      end
    end

    response
  end

  #
  # 抛出异常
  #
  # @example
  #   ResponseStatus.new.__raise__(Response::Code::ERROR, 'some error message')
  #
  # @param code [Code] 编码
  # @param message [String] 信息
  #
  def __raise__(code, message)
    @code = code
    @message = message

    raise StandardError, message
  end

  #
  # 如果参数中的response有异常则抛出异常
  #
  # @example
  #   ResponseStatus.new.__raise__(Response::Code::ERROR, 'some error message')
  #
  # @param code [ResponseStatus] 状态
  #
  def __raise__response__(response_status)
    if response_status.code != Code::SUCCESS
      @code = response_status.code
      @message = response_status.message

      raise StandardError, @message
    end
  end

  def is_successful?
    @code == Code::SUCCESS
  end
end