require 'json'
class Sms
  module TemplateID
    LoginCode = 'RSETSESEKESE'
    PayDone = 'ZL6IQABG7738'
  end
  #
  # 短信网关发送短信
  # @example
  #   Sms.send_sms('13916373635', '测试')
  #
  # @param  receive_phone [String]  手机号码
  #
  # @param  content [String]  短信内容
  #
  # @param  source  [String]  来源
  #
  # @return Symbol 发送结果 成功->:success, 失败->:fail
def self.send_sms(receive_phone, content)
    result = :success
    if receive_phone.blank? || content.blank?
      return :fail
    end
    result = self.sms_jujiang(receive_phone, content)
    return result
  end


  # 智验短信平台 http://www.zhiyan.net
  def self.sms_zhiyan(mobile, use_for, template_params)
    result = :fail
    url = 'http://sms.zhiyan.net/sms/template_send.json'
    return result if url.nil?

    param = {
        apiKey: 'e4d316a72e6d435ba14e0bdb533ed669',
        appId: '03sz3t6922n7',
        mobile: mobile.to_s,
        templateId: use_for,
        param: template_params
    }

    begin
      # 针对不同的测试类型提供不同的post url
      res = nil

      url = URI.parse(url)
      req = Net::HTTP::Post.new(url.path,{'Content-Type' => 'application/json;charset=utf-8', 'Accept' => 'application/json'})
      req.body = param.to_json
      res = Net::HTTP.new(url.host,url.port).start{|http| http.request(req)}

      res_data = JSON.parse(res.body)
      Rails.logger.info(res_data.class)
      if res_data['result'] == 'SUCCESS'
        result = :success
        Rails.logger.info('短信发送成功')
      else
        Rails.logger.info('短信发送失败:'+res_data['reason'])
      end

    rescue => e
      Rails.logger.error do
        ([e.message] + e.backtrace).join("\n")
      end unless e.blank?
    end
    return result
  end

end