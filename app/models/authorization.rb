# == Schema Information
#
# Table name: authorizations
#
#  id                 :integer          not null, primary key
#  provider           :string(255)                            # 提供者(wx,weibo)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  union_id           :string(255)                            # 用户唯一身份id
#  user_id            :integer                                # 关联用户
#  nick_name          :string(255)                            # 第三方昵称
#  owner_id           :integer                                # 关联店铺拥有人
#  avatar             :text(65535)                            # 头像地址
#  gzh_token          :string(255)                            # 公众号token
#  gzh_refresh_token  :string(255)                            # 公众号refresh_token
#  open_token         :string(255)                            # 开放平台token
#  open_refresh_token :string(255)                            # 开放平台refresh_token
#  gzh_open_id        :string(255)                            # 公众号open_id
#  open_open_id       :string(255)                            # 开放平台open_id
#

require 'net/http'
class Authorization < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联用户
  belongs_to :user

  # 关联店铺东家
  belongs_to :owner

  after_save :sync_avatar

  # provider
  module Provider
    # 微信开放平台
    WEIXIN_OPEN = 'weixin_open'

    # 微信公众号
    WEIXIN_GZH = 'weixin_gzh'
  end

  # 公众号来源
  def is_gzh?
    self.provider[Provider::WEIXIN_GZH].present?
  end

  # 开放平台来源
  def is_open?
    self.provider[Provider::WEIXIN_OPEN].present?
  end

  def add_provider(provider)
    if provider == Provider::WEIXIN_GZH

      if self.is_open?
        self.provider = "#{Provider::WEIXIN_GZH},#{Provider::WEIXIN_OPEN}"
      elsif self.is_gzh?

      else
        self.provider = "#{Provider::WEIXIN_GZH}"
      end

    elsif provider == Provider::WEIXIN_OPEN

      if self.is_open?

      elsif self.is_gzh?
        self.provider = "#{Provider::WEIXIN_GZH},#{Provider::WEIXIN_OPEN}"
      else
        self.provider = "#{Provider::WEIXIN_OPEN}"
      end

    end
  end

  # 同步头像
  def sync_avatar
    user = self.user
    if user.present? && self.previous_changes['avatar'].present?
      user.avatar = self.avatar
      user.save
    end
  end

  # 更新用户信息
  def update_profile
    token = nil
    open_id = nil

    url = ''

    if self.is_gzh?
      url = 'https://api.weixin.qq.com/cgi-bin/user/info'
      token = Authorization.get_access_token_for_gzh#self.gzh_token
      open_id = self.gzh_open_id
    elsif self.is_open?
      url = 'https://api.weixin.qq.com/sns/userinfo'
      token = self.open_token
      open_id = self.open_open_id
    else
      return
    end

    url = Authorization.path_with_params(url, access_token: token, openid: open_id, lang: 'zh_CN')
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    body = http.request(request).body

    json = JSON.parse(body,  {:symbolize_names => true})
    self.nick_name = json[:nickname] || '匿名'
    self.avatar = json[:headimgurl]

    self.save!
  end

  def self.path_with_params(page, params)
    return page if params.empty?
    page + '?' + params.map {|k,v| CGI.escape(k.to_s)+'='+CGI.escape(v.to_s) }.join('&')
  end

  # 获取用户token的url
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
  # @return [ResponseStatus] 响应, Auth, User(如果未绑定过为nil), Token(如果未绑定过为nil)
  #
  def self.fetch_access_token_and_open_id(options)

    auth = nil
    token = nil
    user = nil

    catch_proc = proc {
      auth = nil
      token = nil
      user = nil
    }
    response = ResponseStatus.__rescue__(catch_proc) do |res|
      code = options[:code]
      res.__raise__(ResponseStatus::Code::ERROR, '缺失参数') if code.blank?

      json = self.get_user_token(code, WeixinOpenSetting)

      auth_response, auth = self.create_or_update_by_options(json)

      res.__raise__response__(auth_response)
      user = auth.user

      if user.present?
        token = TsaoUtil.sign_jwt_user_session(user.phone)
      end
    end

    return response, auth, user,token
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

      res.__raise__response__(response)
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

      if options[:unionid].blank? || options[:openid].blank? || options[:provider].blank? || options[:access_token].blank? || options[:refresh_token].blank?
        res.__raise__(ResponseStatus::Code::ERROR, '缺失参数')
      end

      auth = self.where(union_id: options[:unionid]).first

      if auth.blank?
        auth = Authorization.new

        auth.gzh_token = options[:access_token] if options[:provider] == Provider::WEIXIN_GZH
        auth.open_token = options[:access_token] if options[:provider] == Provider::WEIXIN_OPEN

        auth.gzh_open_id = options[:openid] if options[:provider] == Provider::WEIXIN_GZH
        auth.open_open_id = options[:openid] if options[:provider] == Provider::WEIXIN_OPEN

        auth.gzh_refresh_token = options[:refresh_token] if options[:provider] == Provider::WEIXIN_GZH
        auth.open_refresh_token = options[:refresh_token] if options[:provider] == Provider::WEIXIN_OPEN

        auth.union_id = options[:unionid]
        auth.provider = options[:provider]

        auth.save!

        auth.update_profile

      else
        auth.gzh_token = options[:access_token] if options[:provider] == Provider::WEIXIN_GZH
        auth.open_token = options[:access_token] if options[:provider] == Provider::WEIXIN_OPEN

        auth.gzh_open_id = options[:openid] if options[:provider] == Provider::WEIXIN_GZH
        auth.open_open_id = options[:openid] if options[:provider] == Provider::WEIXIN_OPEN

        auth.gzh_refresh_token = options[:refresh_token] if options[:provider] == Provider::WEIXIN_GZH
        auth.open_refresh_token = options[:refresh_token] if options[:provider] == Provider::WEIXIN_OPEN

        auth.add_provider(options[:provider])
        auth.save!
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
      order_number = options[:order_number]

      res.__raise__(ResponseStatus::Code::ERROR, '缺失参数') if code.blank? || order_number.blank?

      json = self.get_user_token(code, WeixinGongZhongSetting)

      order = Order.query_first_by_options(order_number: order_number)

      res.__raise__(ResponseStatus::Code::ERROR, '订单信息错误') if order.blank?

      response, red_pack = order.create_or_get_red_pack
      res.__raise__response__(response)

      response, auth = self.create_or_update_by_options(json)

      res.__raise__response__(response)

      # 生成第三方用户暂存优惠券
      response, red_pack, frozen_coupon = RedPack.generate_frozen_coupon_by_options(red_pack_id: red_pack.id, authorization: auth)
      res.__raise__response__(response)

    end
    return response, red_pack, frozen_coupon
  end

  #
  # 查询未绑定过用户的authorization
  #
  # @param options [Hash]
  #
  # @return [Array] 响应, 用户, token
  #
  def self.query_not_binded_by_options(options = {})
    result = self.query_by_options(user_id: nil)

    result = result.where(options) if options.present?

    result
  end


  #(奇怪) 获取公众号基础access_token
  def self.get_access_token_for_gzh
    url = self.path_with_params('https://api.weixin.qq.com/cgi-bin/token', grant_type: 'client_credential', appid: WeixinGongZhongSetting.app_id, secret: WeixinGongZhongSetting.secret)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    body = http.request(request).body

    json = JSON.parse(body,  {:symbolize_names => true})

    return json[:access_token]
  end

end
