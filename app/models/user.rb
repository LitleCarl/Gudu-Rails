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

  # 关联第三方登录
  has_one :authorization

  before_save :set_password_encrypted

  #
  # 绑定微信登录
  #
  # @param options [Hash]
  # @option options [String] :phone 手机号
  # @option options [String] :smsCode 验证码
  # @option options [String] :smsToken token
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
      transaction do
        phone, sms_code, union_id, sms_token = options[:phone], options[:code], options[:union_id], options[:smsToken]

        res.__raise__(ResponseStatus::Code::MISS_PARAM, '缺少参数') if union_id.blank? || phone.blank? || sms_token.blank? || sms_code.blank?

        phone_in_token, code_in_token = TsaoUtil.decode_sms_code(sms_token)

        res.__raise__(ResponseStatus::Code::ERROR, '验证码错误') if phone != phone_in_token || code_in_token != sms_code

        user =  User.query_first_by_options(phone: options[:phone])
        res.__raise__(ResponseStatus::Code::ERROR, '该手机用户已经绑定过其他微信') if user.present? && user.authorization.present?

        response, user, token = self.validate_login_with_sms_token(options)
        res.__raise__response__(response)

        authorization = Authorization.query_first_by_options(union_id: options[:union_id])

        res.__raise__(ResponseStatus::Code::ERROR, '微信可能还没授权') if authorization.blank?

        authorization.user = user
        authorization.save!

        # 同步未领取红包
        authorization.sync_coupons_from_frozen_coupons

        user.avatar = authorization.avatar
        user.save!
      end
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

      user.save!

      options = {
          discount: 2,
          least_price: 3,
          activated_date: Time.now,
          expired_date: Time.now + 7.days,
          user: user
      }

      #TODO 注册用户免费两张优惠券
      Coupon.generate_coupon(options)
      options[:discount] = 3
      options[:least_price] = 5
      Coupon.generate_coupon(options)

    end
    user
  end

  def set_password_encrypted
    if self.changed.include?('password')
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end



end
