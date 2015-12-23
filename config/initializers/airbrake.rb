# encoding: UTF-8

puts "ErrbitSetting.status = #{ErrbitSetting.status}"

if ErrbitSetting.status_open?
  Airbrake.configure do |config|
    config.api_key = ErrbitSetting.api_key
    config.host    = ErrbitSetting.host
    config.port    = ErrbitSetting.port
    config.secure  = config.port == 443
  end
end