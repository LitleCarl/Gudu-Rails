# encoding: utf-8

module Concerns::Management::Api::V1::StoreConcern

  extend ActiveSupport::Concern

  included do
    # 通用查询方法
    include Concerns::Query::Methods
  end

  module ClassMethods

    # 管理者查询该学校的店铺
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [Status] :status 状态(可选)
    # @option options [Integer] :page 状态(可选)
    # @option options [Integer] :limit 状态(可选)
    #
    # @return [Array] response, stores
    #
    def query_for_management(options = {})
      stores = []

      catch_proc = proc{
        stores = []
      }

      response = ResponseStatus.__rescue__(catch_proc) do |res|

        manager, status = options[:manager], options[:status]

        res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank?

        res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

        stores = manager.campus.stores

        stores = stores.where(status: status) if status.present?

        # 分页
        stores = stores.page(options[:page]).per(options[:limit])

        # 排序
        stores = stores.order('stores.created_at asc')
      end

      return response, stores
    end

    # 管理者查询某店铺详情
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [String] :id 店铺id
    #
    # @return [Array] response, stores
    #
    def query_detail_for_management(options = {})
      store = nil

      catch_proc = proc { store = nil }

      response = ResponseStatus.__rescue__(catch_proc) do |res|

        manager, id = options[:manager], options[:id]

        res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank? || id.blank?

        res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

        store = manager.campus.stores.query_first_by_id(id)

        res.__raise__(ResponseStatus::Code::ERROR, '店铺不存在或不再管辖校区内') if store.blank?

      end

      return response, store
    end

  end

end
