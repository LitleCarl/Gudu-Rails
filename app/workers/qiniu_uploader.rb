require 'qiniu'

class QiniuUploader
  include Sidekiq::Worker

  # 上传文件到七牛
  def perform(filename)
    # 已在某处调用Qiniu#establish_connection!方法

    put_policy = Qiniu::Auth::PutPolicy.new(
        'gudu',     # 存储空间
        'test_key',        # 最终资源名，可省略，即缺省为“创建”语义
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    code, result, response_headers = Qiniu::Storage.upload_with_put_policy(
        put_policy,     # 上传策略
        filename,     # 本地文件名
    )
  end
end

