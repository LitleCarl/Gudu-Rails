class SignUpSmsWorker
  include Sidekiq::Worker

  def perform(phone, code)
    template_params = {code: code, product: '早餐巴士'}
    Sms.sms_alidayu(phone, Sms::TemplateID::ALI_LoginCode, template_params)
  end
end