# == Schema Information
#
# Table name: managers
#
#  id                     :integer          not null, primary key
#  phone                  :string(255)      default(""), not null  # 手机号
#  campus_id              :integer                                 # 所属校区
#  write                  :boolean                                 # 修改权限
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

class Manager < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联学校
  belongs_to :campus

  #
  # 发送登录短信验证码
  #
  # @param options [Hash]
  # @option options [String] :phone 手机号
  #
  # @return [Array] 响应, token
  #
  def self.send_sign_in_code(options = {})
    token = nil
    response = ResponseStatus.__rescue__ do |res|
      phone = options[:phone]

      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if phone.blank? || !RegularTest.is_phone_number(phone)

      token = TsaoUtil.send_sms_code(phone, TsaoUtil::Usage::MANAGER_SIGN_IN)

    end
    return response, token
  end
  #
  # 短信登录验证
  #
  # @param options [Hash]
  # @option options [String] :phone 手机号
  # @option options [String] :sms_code 验证码
  # @option options [String] :sms_token token
  #
  # @return [Array] 响应, 管理者, token
  #
  def self.validate_login_with_sms_token(options)
    manager = nil
    token = nil

    catch_proc = proc{
      manager = nil
      token = nil
    }

    response = ResponseStatus.__rescue__(catch_proc) do |res|
      phone, sms_code, sms_token = options[:phone], options[:sms_code], options[:sms_token]
      phone_in_token, sms_code_in_token, usage = TsaoUtil.decode_sms_code(sms_token)

      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if phone.blank? || sms_code.blank? || sms_token.blank?

      if phone_in_token == phone && sms_code_in_token == sms_code && usage == TsaoUtil::Usage::MANAGER_SIGN_IN
        manager = Manager.query_first_by_options(phone: phone)

        res.__raise__(ResponseStatus::Code::ERROR, '抱歉,您不是管理者') if manager.blank?

        token = TsaoUtil.sign_jwt_user_session(phone)
      else
        res.__raise__(ResponseStatus::Code::ERROR, '验证码错误或失效')
      end
    end

    return response, manager, token
  end
end
