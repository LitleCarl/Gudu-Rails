class OrderPayDoneSmsWorker
  include Sidekiq::Worker

  # 您的订单已经发货成功
  def perform(order_id)
    order = Order.find(order_id)
    if order.present?
      time_paid, price, delivery_time = Sms.wrap_pay_done_param(order_id)
      if time_paid.present? && price.present? && delivery_time.present?
        param = "#{time_paid},#{price},#{delivery_time}"
        Sms.sms_zhiyan(order.receiver_phone, Sms::TemplateID::PayDone, param)
      end
    end

  end
end