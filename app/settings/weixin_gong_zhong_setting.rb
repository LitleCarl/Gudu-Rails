# encoding: UTF-8

class WeixinGongZhongSetting < Settingslogic
  source "#{Rails.root}/config/weixin_gong_zhong_config.yml"
  namespace Rails.env
end