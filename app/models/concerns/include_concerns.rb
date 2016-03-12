# encoding: utf-8

module Concerns::IncludeModules
  extend ActiveSupport::Concern

  # 添加公有的查询方法
  include Concerns::Query::Methods

  # 添加模型属性国际化方法
  include Concerns::Dictionary::Attribute::I18n

  # 多行定义值替换正则表达式
  # MULTI_LINE_REGEXP = /(\r\n)|(\r)|(\n)/

  # 模型方法
  included do
    # # 引入paper trail记录数据库记录
    # has_paper_trail
    #
    # # 软删除
    # acts_as_paranoid
    #
    # # 添加软删除验证
    # validates_as_paranoid
    #
    # # 混淆ID
    # obfuscate_id
    #
    # # 根据scheme添加模型验证
    # schema_validations except: [:created_at, :updated_at]
  end
end
