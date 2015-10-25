# encoding: UTF-8

puts "SidekiqRedisSetting.status = #{SidekiqRedisSetting.status}"

if SidekiqRedisSetting.status == 'open'

  SidekiqRedisSetting.connect

  # https://github.com/mperham/sidekiq/wiki/Advanced-Options
  sidekiq_redis_url = "redis://#{SidekiqRedisSetting.username}:#{SidekiqRedisSetting.password}@#{SidekiqRedisSetting.host}:#{SidekiqRedisSetting.port}/12"
  sidekiq_redis_params = { :url => sidekiq_redis_url, :namespace => SidekiqRedisSetting.namespace}#, driver: :synchrony}

  Sidekiq.configure_server do |config|
    config.redis = sidekiq_redis_params

    ActiveRecord::Base.configurations['production']['pool'] = 50

    # https://github.com/layervault/sidekiq-gelf-rb
    # Adds the GELF logger as middleware in Sidekiq in order
    # to include important logging information.
    # These arguments are passed through to gelf-rb.
    #Sidekiq::Logging::GELF.hook!(GelfSetting.host, GelfSetting.port, 'WAN', facility: "#{GelfSetting.facility}-sidekiq") if defined? Sidekiq::Logging::GELF
  end

  Sidekiq.configure_client do |config|
    config.redis = sidekiq_redis_params
  end

end
