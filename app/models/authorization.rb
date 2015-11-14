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
#  user_id       :integer
#

class Authorization < ActiveRecord::Base

  belongs_to :user

  # provider
  module Provider
    # 微信开放平台
    WEIXIN_OPEN = 'weixin_open'

    # 微信公众号
    WEIXIN_GZH = 'weixin_gzh'
  end

  # 更新用户信息
  def update_profile
    url = ''
    if self.provider == Provider::WEIXIN_GZH
      url = 'https://api.weixin.qq.com/cgi-bin/user/info'
    else
      url = 'https://api.weixin.qq.com/sns/userinfo'
    end

    url = Authorization.path_with_params(url, access_token: self.token, openid: self.open_id, lang: 'zh_CN')
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    body = http.request(request).body

    json = JSON.parse(body,  {:symbolize_names => true})
    self.nick_name = json[:nickname] || '匿名'
    self.save!
  end

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


  def self.get_user_token(code, setting)
    uri = URI.parse(self.get_token_url(code, setting))

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    body = http.request(request).body

    json = JSON.parse(body,  {:symbolize_names => true})

    if setting == WeixinGongZhongSetting
      json[:provider] = Provider::WEIXIN_GZH
    else
      json[:provider] = Provider::WEIXIN_OPEN
    end

    json
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
      res.__raise__(ResponseStatus::Code::ERROR, '缺失参数') if code.blank?

      json = self.get_user_token(code, WeixinOpenSetting)

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

    catch_proc = proc {
      auth = nil
    }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      code = options[:code]

      res.__raise__(ResponseStatus::Code::ERROR, '缺失参数') if code.blank?

      json = self.get_user_token(code, WeixinGongZhongSetting)

      response, auth = self.create_or_update_by_options(json)
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

    # TODO 公众号出炉后需要更新
    options[:unionid] = 'o6TlUw19J7RhdPOtugs3UkWoTMBk' if options[:unionid].blank?
    auth = nil

    response = ResponseStatus.__rescue__ do |res|

      if options[:unionid].blank? || options[:openid].blank? || options[:provider].blank? || options[:access_token].blank? || options[:refresh_token].blank?
        res.__raise__(ResponseStatus::Code::ERROR, '缺失参数')
      end

      auth = self.where(union_id: options[:unionid]).first

      if auth.blank?
        auth = Authorization.new
        auth.token = options[:access_token]
        auth.union_id = options[:unionid]
        auth.open_id = options[:openid]
        auth.refresh_token = options[:refresh_token]
        auth.provider = options[:provider]
        auth.save!

        auth.update_profile
      end

    end
    return response, auth
  end

  #
  # 微信客户端获取红包的redirect_url
  #
  # @param options [Hash]
  # @option options [String] :code 微信授权代码
  # @option options [String] :red_pack_id 红包代码
  #
  # @return [ResponseStatus] 响应
  #
  def self.get_frozen_coupon_by_weixin_authorization(options)

    frozen_coupon = nil
    red_pack = nil

    catch_proc = proc {
      frozen_coupon = nil
      red_pack = nil
    }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      code = options[:code]
      red_pack_id = options[:red_pack_id]

      res.__raise__(ResponseStatus::Code::ERROR, '缺失参数') if code.blank? || red_pack_id.blank?

      json = self.get_user_token(code, WeixinGongZhongSetting)

      temp, auth = self.create_or_update_by_options(json)

      res.__raise_response_if_essential__(temp)

      # 生成第三方用户暂存优惠券
      temp, red_pack, frozen_coupon = RedPack.generate_frozen_coupon_by_options(red_pack_id: red_pack_id, authorization: auth)
      res.__raise_response_if_essential__(temp)

    end
    puts "get_frozen_coupon_by_weixin_authorization:#{response.message}"
    return response, red_pack, frozen_coupon

  end

end
