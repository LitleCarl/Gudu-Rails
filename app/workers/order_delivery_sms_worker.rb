class OrderDeliverySmsWorker
  include Sidekiq::Worker

  def perform(phone, order_id)

    response = ResponseStatus.__rescue__ do |res|

      res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if phone.blank? || order_id.blank?

      order = Order.query_first_by_id(order_id)

      res.__raise__(ResponseStatus::Code::ERROR, '订单不存在') if order.blank?

      name, phone, delivery_time = order.expresser.name, order.expresser.phone, order.delivery_time

      res.__raise__(ResponseStatus::Code::ERROR, '订单派送员信息不存在') if order.expresser.blank?

      template_params = {order_number: order.order_number, name: name,phone: phone, delivery_time: delivery_time}
      Sms.sms_alidayu(phone, Sms::TemplateID::ALI_LoginCode, template_params)
    end

    response
  end
end