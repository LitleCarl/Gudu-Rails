class TsaoUtil < Settingslogic
  source "#{Rails.root}/config/jwt.yml"
  namespace Rails.env
  def self.sign_jwt_user_session(phone = '')
    exp = Time.now.to_i + 4 * 3600 #4小时
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

  # 发送登录短信验证码
  def self.send_login_sms_code(phone, code)
    return if phone.blank?
    exp = Time.now.to_i + 120 #2分钟
    payload = {phone: phone, smsCode: code, exp: exp}
    token = JWT.encode payload, TsaoUtil[:secret], 'HS256'
    token
  end

  def self.decode_sms_code(token)
    phone, sms_code = nil, nil
    begin
      token = JWT.decode(token, TsaoUtil[:secret], true, {algorithm: 'HS256'})
      phone, sms_code = token[0]['phone'], token[0]['smsCode']
    rescue Exception
      nil
    end
    return phone, sms_code
  end

end