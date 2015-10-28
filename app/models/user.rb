# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  phone      :string(255)      not null
#  password   :string(255)      default("e10adc3949ba59abbe56e057f20f883e"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  has_many :orders
  has_many :addresses
  has_one :cart
  before_save :set_password_encrypted

  # 短信登录验证
  def self.validate_login_with_sms_token(params)
    response_status = ResponseStatus.default
    user = nil
    token = nil
    begin
      raise RestError::MissParameterError if params[:phone].blank? || params[:smsCode].blank? || params[:smsToken].blank?
      phone, sms_code = TsaoUtil.decode_sms_code(params[:smsToken])
      if params[:phone] == phone && params[:smsCode] == sms_code
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
  end

  def set_password_encrypted
    if self.changed.include?('password')
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end



end
