# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  content    :text(65535)                            # 通知内容
#  link       :string(255)                            # 链接地址
#  platform   :integer          default("0")          # 平台
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Announcement < ActiveRecord::Base

  # 通用查询方法
  include Concerns::Query::Methods

  # 平台
  module Platform
    include Concerns::Dictionary::Module::I18n

    # iPhone
    IPHONE = 'iphone'

    # Android
    ANDROID = 'android'

    # 全部
    ALL = get_all_values
  end

  #
  # 获取最新通知
  #
  # @param options [Hash]
  #
  # @return [ResponseStatus] 响应
  def self.query_newest_with_options(options)
    announcement = nil

    response = ResponseStatus.__rescue__ do |res|
      platform = options[:platform]

      if platform.present?
        announcement = Announcement.query_with_options(platform: platform).last
      else
        announcement = Announcement.last
      end

      res.__raise__(ResponseStatus::Code::ERROR, '暂无数据') if announcement.blank?

    end

    return response, announcement
  end
end
