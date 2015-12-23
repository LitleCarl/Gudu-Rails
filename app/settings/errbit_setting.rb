# encoding: UTF-8

# binarylogic/settingslogic
# https://github.com/binarylogic/settingslogic
class ErrbitSetting < Settingslogic
  source "#{Rails.root}/config/errbit.yml"
  namespace Rails.env

  #
  # 启用与否
  # @example
  #   ErrbitSetting.status_open?
  #
  # @return Boolean 启用与否.
  #
  def self.status_open?
    self.status == 'open'
  end
end