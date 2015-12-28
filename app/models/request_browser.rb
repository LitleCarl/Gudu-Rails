#encoding: utf-8

class RequestBrowser

  #
  # 微信浏览器.
  #
  # @example
  #   RequestBrowser.weixin_browser??(request)
  #
  # @param  request [Request] 请求
  #
  # @return Boolean true - 微信浏览器, false - 其它浏览器
  #
  def self.weixin_browser?(request)
    http_user_agent = request.env['HTTP_USER_AGENT']

    http_user_agent.include?('MicroMessenger') if http_user_agent.present?
  end

  #
  # QQ浏览器.
  #
  # @example
  #   RequestBrowser.qq_browser?(request)
  #
  # @param  request [Request] 请求
  #
  # @return Boolean true - QQ浏览器, false - 其它浏览器
  #
  def self.qq_browser?(request)
    http_user_agent = request.env['HTTP_USER_AGENT']

    http_user_agent.include?('QQ') if http_user_agent.present?
  end

  def self.is_iphone?(request)
    request.user_agent.include?('iPhone')
  end

  def self.is_android?(request)
    request.user_agent.include?('Android')
  end

end