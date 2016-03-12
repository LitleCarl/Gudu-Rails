::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "BdUcFkkzxD3cbYuK7xttLeJztckRlsT3HdtSifh4"
  config.qiniu_secret_key    = 'cwHXRxCpmi_kqPjsICLwMZE0j80iw-SrmEEuu8c3'
  config.qiniu_bucket        = "gudu"
  config.qiniu_bucket_domain = "7xnsaf.com1.z0.glb.clouddn.com"
  config.qiniu_bucket_private= false
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = 'http'

  # config.qiniu_up_host       = 'http://up.qiniug.com' #七牛上传海外服务器,国内使用可以不要这行配置
end