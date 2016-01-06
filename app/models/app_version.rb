class AppVersion

  module DownloadURL
    # 安卓
    ANDOIRD_URL = 'http://fusion.qq.com/app_download?appid=1104986485&platform=qzone&via=QZ.MOBILEDETAIL.QRCODE&u=3046917960'

    # iPhone
    IPHONE_URL = 'https://itunes.apple.com/cn/app/zao-can-ba-shi/id1057051323?l=zh&ls=1&mt=8'
  end

  module Platform
    # 安卓
    ANDOIRD = 'Android'

    # iPhone
    IPHONE = 'iPhone'
  end
  #
  # 检查app是否需要更新
  #
  # @param options [Hash]
  # option options [platform] :从此订单号开始打印
  # option options [current_version] :App当前版本
  #
  # @return [Response, Array] 状态，学校列表
  #
  def self.check_update(options = {})
    android_versions = %w(2.0.1 2.0.2)
    iphone_versions = %w(1.0.3 1.0.4)

    android_update_messages = '添加更新通知, 修复微信登录异常(2.0.2)'
    iphone_update_messages = '添加更新通知, 修复微信登录异常,优惠券显示问题(1.0.4)'

    result = {
        need_update: false,
        update_message: '',
        download_url: ''
    }

    response = ResponseStatus.__rescue__ do |res|

      platform = options[:platform]
      current_version = options[:current_version]

      res.__raise__(ResponseStatus::Code::ERROR, "缺失参数") if platform.blank? || current_version.blank?

      # 检查安卓
      if platform == Platform::ANDOIRD
        index = android_versions.index(current_version)

        if index.blank? || index < (android_versions.count - 1)
          result[:need_update] = true
          result[:update_message] = android_update_messages
          result[:download_url] = DownloadURL::ANDOIRD_URL
        end

      elsif platform == Platform::IPHONE
        index = iphone_versions.index(current_version)

        if index.blank? || index < (android_versions.count - 1)
          result[:need_update] = true
          result[:update_message] = iphone_update_messages
          result[:download_url] = DownloadURL::IPHONE_URL
        end
      end
    end

    return response, result

  end
end