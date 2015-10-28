class Sms
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


  # 巨匠一码通平台
  # @example
  #   Sms.send_sms_by_jujiang(13916373635)
  #
  # @param  mobile  [String, nil]  手机号码
  #
  # @param  content  [String, nil]  短信内容
  #
  # @return Symbol 发送结果 成功->:success, 失败->:fail
  #
  # jujiang:
  #   site: 'http://218.207.176.76:9000/sendXSms.do'
  #   username: 'imbox'
  #   password: 'imbox123'
  #   product_id: 669141
  def self.sms_jujiang(mobile, content = "", msg_type = 0)
    result = :fail
    url = 'http://218.207.176.76:9000/sendXSms.do'
    return result if url.nil?

    username = 'imbox'
    password =  'imbox123'
    product_id = '669141'

    begin
      # 针对不同的测试类型提供不同的post url
      res = nil
      if msg_type == 0
        res = Net::HTTP.post_form(URI.parse(url), username: username, password: password, mobile: mobile, content: content,productid: product_id)
      elsif msg_type == 1
        res = Net::HTTP.post_form(URI.parse(url),username: username, password: password,mobile: mobile, title: '', content: content,product_id: product_id)
      elsif msg_type == 2
        res = Net::HTTP.post_form(URI.parse(url),username: username, password: password, product_id: product_id)
      end
      return_code = res.body
      return_msg = get_msg_by_code_for_jujiang(msg_type,return_code)

      Rails.logger.info "返回参数: #{return_code}, 描述: #{return_msg}"
      if return_msg == '成功'
        result = :success
      end
    rescue => e
      Rails.logger.error do
        ([e.message] + e.backtrace).join("\n")
      end unless e.blank?
    end
    return result
  end

  # 服务端返回的信息
  def self.get_msg_by_code_for_jujiang(test_type,code)
    if test_type == 0 || test_type == 1
      res_des = %w{失败 成功 余额不够 黑词审核中 出现异常人工处理中 提交频率太快 有效号码为空 短信内容为空 一级黑词 没有url提交权限 发送号码过多 产品ID异常 参数异常 用户名或者密码不正确}
      if /^1,/ =~ code
        code = '1'
      elsif /^8,/ =~ code
        code = '8'
      end
      code = code.to_i
      res_des[code]

    elsif test_type == 2
      Rails.logger.info "in elsif : code : #{code}, code.class : #{code.class}"
      case code
        # !!! 这里有个问题，API上给出的参数是-2，但实际上返回值包含了很多其他空字符，所以用如下规则匹配
        when /^-2/
          '失败'
        when '-1'
          '用户名或者密码不正确'
        when '-5'
          '提交频率太快'
        when '-9'
          '没有url提交权限'
        else
          "剩余条数：#{code}"
      end
    end
  end
end