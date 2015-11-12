# encoding: UTF-8

class WeixinOpenSetting < Settingslogic
  source "#{Rails.root}/config/weixin_open_config.yml"
  namespace Rails.env
end