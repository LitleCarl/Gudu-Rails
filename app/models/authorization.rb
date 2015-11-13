require 'net/http'
# == Schema Information
#
# Table name: authorizations
#
#  id            :integer          not null, primary key
#  open_id       :string(255)
#  provider      :string(255)
#  token         :string(255)
#  refresh_token :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  union_id      :string(255)
#

class Authorization < ActiveRecord::Base

  def self.path_with_params(page, params)
    return page if params.empty?
    page + '?' + params.map {|k,v| CGI.escape(k.to_s)+'='+CGI.escape(v.to_s) }.join('&')
  end

  # 获取用户信息的url
  #
  # @param code [String] 微信授权的code
  # @param setting [Class] WeixinOpenSetting/WeixinGongzhongSetting
  #
  #
  def self.get_token_url(code, setting)
    self.path_with_params('https://api.weixin.qq.com/sns/oauth2/access_token', appid: setting.app_id, secret: setting.secret, grant_type: 'authorization_code', code: code)
  end

  #
  #
  # 从ios客户端微信登录后回调此请求来验证用户,并加入数据库Authorization
  #
  # @param options [Hash]
  # @option options [String] :code 刷新token的代号
  #
  # @return [ResponseStatus] 响应
  #
  def self.fetch_access_token_and_open_id(options)

    auth = nil

    response = ResponseStatus.__rescue__ do |res|
      code = options[:code]
      res.__raise__(Response::Code::ERROR, '缺失参数') if options[:code].blank?

      uri = URI.parse(self.get_token_url(code, WeixinOpenSetting))

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      body = response.body
      json = JSON.parse(body)

      json['provider'] = 'weixin'



      auth_response, auth = self.create_or_update_by_options(json)

      temp_res = ResponseStatus.merge_status(res, auth_response)

      res.code = temp_res.code
      res.message = temp_res.message
    end

    return response, auth
  end

  #
  #
  # 从微信浏览器登录后回调此请求来验证用户,并加入数据库Authorization
  #
  # @param options [Hash]
  # @option options [String] :code 刷新token的代号
  #
  # @return [ResponseStatus] 响应
  #
  def self.fetch_access_token_and_open_id_by_weixin_client(options)

    auth = nil

    response = ResponseStatus.__rescue__ do |res|
      code = options[:code]
      res.__raise__(Response::Code::ERROR, '缺失参数') if options[:code].blank?

      uri = URI.parse(self.get_token_url(code, WeixinOpenSetting))

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      body = response.body
      json = JSON.parse(body)

      json['provider'] = 'weixin'



      auth_response, auth = self.create_or_update_by_options(json)

      temp_res = ResponseStatus.merge_status(res, auth_response)

      res.code = temp_res.code
      res.message = temp_res.message
    end

    return response, auth
  end

  #
  # 根据union_id来创建授权
  #
  # @param options [Hash]
  # @option options [String] :union_id
  # @option options [String] :open_id
  # @option options [String] :provider 提供者
  # @option options [String] :access_token token
  # @option options [String] :refresh_token 刷新token
  #
  # @return [ResponseStatus] 响应
  #
  def self.create_or_update_by_options(options)

    auth = nil

    response = ResponseStatus.__rescue__ do |res|

      message = nil

      if options['unionid'].blank? || options['openid'].blank? || options['provider'].blank? || options['access_token'].blank? || options['refresh_token'].blank?
        res.__raise__(ResponseStatus::Code::ERROR, '缺失参数')
      end

      auth = self.where(union_id: options['unionid']).first

      if auth.blank?
        auth = Authorization.new
        auth.token = options['access_token']
        auth.union_id = options['unionid']
        auth.open_id = options['openid']
        auth.refresh_token = options['refresh_token']
        auth.provider = options['provider']
        auth.save!
      end

    end
    return response, auth
  end

end
