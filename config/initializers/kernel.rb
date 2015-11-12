# encoding: utf-8

# 为 Kernel 添加方法
module Kernel
  #
  # 简化 #Hashie::Mash 的使用
  #
  # @param options [Hash] 需要转化的Hash
  #
  # @return [Hashie::Mash] 转化后的对象
  #
  def yunhash(options = {})
    Hashie::Mash.new(options)
  end

  #
  # yunhash 方法的别名
  #
  alias :yhash :yunhash

  #
  # 申明为模块方法（私有方法和模块的特殊方法）
  #
  module_function :yhash, :yunhash

  #
  # 元深日志输出
  #
  # @param exception [Exception] 异常对象
  # @param message [String, nil] 异常补充说明
  # @param request [String, nil] 请求信息
  #
  def yunlog_exception(exception, message = nil, request = nil)
    return if exception.blank?

    # 不输出导入自定义异常的堆栈 减少不必要的日志
    # 转化为 Rails.logger.info 输出
    return ylogi (message || exception.message) if exception.is_a? YunError

    # ExceptionLogger.lta(exception, message, request)

    full_message = "#{exception.message} : #{exception.class}\n"

    backtrace = exception.backtrace

    full_message << backtrace.join("\n") if backtrace.present?

    Rails.logger.error full_message
  end

  #
  # yunlog_exception 方法的别名
  #
  alias :yloge :yunlog_exception

  #
  # 申明为模块方法（私有方法和模块的特殊方法）
  #
  module_function :yloge, :yunlog_exception

  #
  # 简化 Rails.logger.info
  #
  # @param message [String, nil] 信息
  # @param block [Block] 块
  #
  def yunlog_info(message = nil, &block)
    Rails.logger.info message, &block
  end

  #
  # yunlog_info 方法的别名
  #
  alias :ylogi :yunlog_info

  #
  # 申明为模块方法（私有方法和模块的特殊方法）
  #
  module_function :ylogi, :yunlog_info

  #
  # 简化 Rails.logger.debug
  #
  # @param message [String, nil] 信息
  # @param block [Block] 块
  #
  def yunlog_debug(message = nil, &block)
    Rails.logger.debug message, &block
  end

  #
  # yunlog_debug 方法的别名
  #
  alias :ylogd :yunlog_debug

  #
  # 申明为模块方法（私有方法和模块的特殊方法）
  #
  module_function :ylogd, :yunlog_debug
end