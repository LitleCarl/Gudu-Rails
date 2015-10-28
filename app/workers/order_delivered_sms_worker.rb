class OrderDeliveredSmsWorker
  include Sidekiq::Worker

  def perform(phone)
    content_template = '测试短信19'#(您的订单已经发货成功)
    Sms.send_sms(phone, content_template)
  end
end