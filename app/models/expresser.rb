# == Schema Information
#
# Table name: expressers
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null              # 快递员名字
#  phone      :string(255)      not null              # 手机号
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  password   :string(255)      default("123456")     # 密码
#

class Expresser < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 关联物流
  has_many :expresses

  #
  # 送货员登录
  #
  # @param options [Hash]
  # @option options [String] :phone 手机号
  # @option options [String] :password 密码
  #
  # @return [Array] 响应, 用户, token
  #
  def self.sign_in(options = {})
    expresser = nil
    token = nil

    catch_proc = proc {
      expresser = nil
      token = nil
    }
    response = ResponseStatus.__rescue__(catch_proc) do |res|
      phone, password = options[:phone], options[:password]

      res.__raise__(ResponseStatus::Code::MISS_PARAM, '缺少参数') if password.blank? || phone.blank?

      expresser = Expresser.query_first_by_options(phone: phone, password: password)

      res.__raise__(ResponseStatus::Code::ERROR, '送货员信息不存在') if expresser.blank?

      exp = Time.now.to_i + 24 * 30 * 3600 # 30天session
      payload = {express_phone: phone, exp: exp}
      token = JWT.encode payload, TsaoUtil[:secret], 'HS256'

    end

    return response, expresser, token
  end

end
