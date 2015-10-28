class SignUpSmsWorker
  include Sidekiq::Worker

  def perform(phone, code)
    Sms.sms_zhiyan(phone, Sms::TemplateID::LoginCode, code.to_s)
  end
end