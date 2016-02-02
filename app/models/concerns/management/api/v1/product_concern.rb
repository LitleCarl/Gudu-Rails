# encoding: utf-8

module Concerns::Management::Api::V1::ProductConcern

  extend ActiveSupport::Concern

  included do
    # 通用查询方法
    include Concerns::Query::Methods
  end

  module ClassMethods

    # 管理者查询该店铺的商品
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [Status] :status 状态(可选)
    # @option options [String] :store_id 商铺id
    # @option options [Integer] :page 状态(可选)
    # @option options [Integer] :limit 状态(可选)
    #
    # @return [Array] response, stores
    #
    def query_store_products_for_management(options = {})
      products = []
      store = nil

      catch_proc = proc{
        products = []
        store = nil
      }

      response = ResponseStatus.__rescue__(catch_proc) do |res|

        manager, status, store_id = options[:manager], options[:status], options[:store_id]

        res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank? || store_id.blank?

        res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

        store = manager.campus.stores.query_first_by_id(store_id)

        res.__raise__(ResponseStatus::Code::ERROR, '不存在店铺或不再管辖范围内') if store.blank?

        products = store.products

        products = products.query_with_options(status: status) if status.present?

        products = products.order('id desc').page(options[:page]).per(options[:limit])
      end

      return response, store, products
    end

  end

end
