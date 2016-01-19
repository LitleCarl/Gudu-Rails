# encoding: UTF-8

class JpushTool

  # 推送类型
  module Category
    # 引入常量国际化模块
    include Concerns::Dictionary::Module::I18n

    # 消息
    MESSAGE = 'message'

    # 全部
    ALL = get_all_values
  end

  #
  # 发送推送
  #
  # @param options [Hash] 请求参数
  # @option options [String] :title 标题
  # @option options [Category] :category 推送类型
  # @option options [String] :phone 手机号
  #
  # @return [Array] response 状态, result 发送结果
  #
  def self.push(options = {})
    result = nil

    response = ResponseStatus.__rescue__ do |res|
      title, category, phone = options[:title], options[:category], options[:phone]

      res.__raise__(ResponseStatus::Code::ERROR, '参数缺失') if title.blank? || category.blank? || phone.blank?

      client = JPush::JPushClient.new(JpushSetting.app_key, JpushSetting.secret)

      payload = JPush::PushPayload.new(platform: JPush::Platform.all,
                                       audience: JPush::Audience.new(_alias: [phone]),
                                       notification: JPush::Notification.build(alert: title, ios: JPush::IOSNotification.new(badge: '+1', extras: {category: category})),
                                       options: JPush::Options.new(apns_production: false))

      result = client.sendPush(payload)

      Rails.logger.info("JPush 推送结果: #{result}")
    end

    return response, result
  end

end
