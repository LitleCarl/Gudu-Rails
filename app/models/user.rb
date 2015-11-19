# == Schema Information
#
# Table name: users # 用户表
#
#  id         :integer          not null, primary key                                 # 用户表
#  phone      :string(255)      not null                                              # 用户手机
#  password   :string(255)      default("e10adc3949ba59abbe56e057f20f883e"), not null # 用户密码 默认123456
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar     :text(65535)                                                            # 用户头像
#

class User < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联订单
  has_many :orders

  # 关联地址
  has_many :addresses

  # 关联购物车
  has_one :cart

  # 关联优惠券
  has_many :coupons

  before_save :set_password_encrypted

  #
  # 绑定微信登录
  #
  # @param options [Hash]
  # @option options [String] :message_id 内容
  # @option options [Status] :status 状态
  # @option options [User] :user 消息接受者
  # @option options [String] :union_id 微信联合id
  #
  # @return [Array] 响应, 用户, token
  #
  def self.bind_weixin(options = {})
    user = nil
    token = nil

    catch_proc = proc {
      user = nil
      token = nil
    }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      res.__raise__(ResponseStatus::Code::MISS_PARAM, '缺少参数') if options[:union_id].blank?

      response, user, token = self.validate_login_with_sms_token(options)
      res.__raise__response__(response)

      authorization = Authorization.query_not_binded_by_options(union_id: options[:union_id]).first

      res.__raise__(ResponseStatus::Code::ERROR, '微信可能还没授权') if authorization.blank?

      authorization.user = user
      authorization.save!

      user.avatar = authorization.avatar
    end

    return response, user, token
  end

  #
  # 短信登录验证
  #
  # @param options [Hash]
  # @option options [String] :phone 手机号
  # @option options [String] :smsCode 验证码
  # @option options [String] :smsToken token
  #
  # @return [Array] 响应, 用户, token
  #
  def self.validate_login_with_sms_token(options)
    response_status = ResponseStatus.default
    user = nil
    token = nil

    begin
      raise RestError::MissParameterError if options[:phone].blank? || options[:smsCode].blank? || options[:smsToken].blank?
      phone, sms_code = TsaoUtil.decode_sms_code(options[:smsToken])
      if options[:phone] == phone && options[:smsCode] == sms_code
        user = User.upsert_user_if_not_found(phone)
        token = TsaoUtil.sign_jwt_user_session(phone)
        response_status = ResponseStatus.default_success
      else
        response_status.message = '验证码不正确'
      end
    rescue Exception => ex
      Rails.logger.error(ex.message)
      response_status.message = ex.message
    end

    return response_status, user, token
  end

  # 如果此用户不存在则创建此用户并返回
  def self.upsert_user_if_not_found(phone = '')
    user = User.where({phone: phone}).first
    if user.blank?
      user = User.new
      user.phone = phone
      user.password = '123456'
      user.save
    end
    user
  end

  def set_password_encrypted
    if self.changed.include?('password')
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end



end
