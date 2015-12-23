# encoding: UTF-8

puts "ErrbitSetting.status = #{ErrbitSetting.status}"

if ErrbitSetting.status_open?
  Airbrake.configure do |config|
    config.api_key = ErrbitSetting.api_key
    config.host    = ErrbitSetting.host
    config.port    = ErrbitSetting.port
    config.secure  = config.port == 443

    # # allow all environments
    # config.development_environments = []
    #
    # config.async do |notice|
    #   AirbrakeDeliveryWorker.perform_async(notice.to_xml)
    # end
    #config.user_attributes += [:id]

    # config.logger = Logger.new("#{Rails.root}/log/errbit.log")
  end
end