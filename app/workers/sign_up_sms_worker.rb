class SignUpSmsWorker
  include Sidekiq::Worker

  def perform(phone, code)
    content_template = '注册验证码[:code],如非本人操作请忽略'
    content_template[':code'] = code.to_s
    Sms.send_sms(phone, content_template)
  end
end