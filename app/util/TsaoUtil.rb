class TsaoUtil < Settingslogic
  source "#{Rails.root}/config/jwt.yml"
  namespace Rails.env
  def self.sign_jwt_user_session(phone = '')
    exp = Time.now.to_i + 4 * 3600
    payload = {phone: phone, exp: exp}
    token = JWT.encode payload, TsaoUtil[:secret], 'HS256'
    token
  end
  def self.decode_jwt_user_session(token = '')
    begin

      token = JWT.decode(token, TsaoUtil[:secret], true, {algorithm: 'HS256'})
      token[0][:phone]
    rescue Exception
        nil
    end

  end

end