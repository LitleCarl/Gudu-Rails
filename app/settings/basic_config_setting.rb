# encoding: UTF-8

class BasicConfigSetting < Settingslogic
  source "#{Rails.root}/config/basic_config.yml"
  namespace Rails.env
end