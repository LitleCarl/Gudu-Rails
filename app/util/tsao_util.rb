class TsaoUtil < Settingslogic
  source "#{Rails.root}/config/jwt.yml"
  namespace Rails.env

  # TOKEN用途
  module Usage
    # 用户登录
    USER_SIGN_IN = 'user_sign_in'

    # 管理者登录
    MANAGER_SIGN_IN = 'manager_sign_in'
  end

  def self.sign_jwt_user_session(phone = '')
    exp = Time.now.to_i + 24 * 30 * 3600 # 30天session
    payload = {phone: phone, exp: exp}
    token = JWT.encode payload, TsaoUtil[:secret], 'HS256'
    token
  end

  def self.decode_jwt_user_session(token = '')
    begin
      token = JWT.decode(token, TsaoUtil[:secret], true, {algorithm: 'HS256'})
      token[0]['phone']
    rescue Exception
        nil
    end
  end

  # 发送短信验证码并返回token
  def self.send_sms_code(phone, usage = '')
    return if phone.blank?
    exp = Time.now.to_i + 240 #4分钟
    code = Random.rand(1000..9999).to_s
    SignUpSmsWorker.perform_async(phone, code)
    payload = {phone: phone, smsCode: code, exp: exp, usage: usage}
    token = JWT.encode payload, TsaoUtil[:secret], 'HS256'
    token
  end

  def self.decode_sms_code(token)
    phone, sms_code = nil, nil
    begin
      token = JWT.decode(token, TsaoUtil[:secret], true, {algorithm: 'HS256'})
      phone, sms_code, usage = token[0]['phone'], token[0]['smsCode'], token[0]['usage']
    rescue Exception
      nil
    end
    return phone, sms_code, usage
  end

end