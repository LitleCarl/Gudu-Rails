# encoding: utf-8

module Concerns::Management::Api::V1::StoreConcern

  extend ActiveSupport::Concern

  included do
    # 通用查询方法
    include Concerns::Query::Methods
  end


  # 获取店铺某一日的(属于某一校区)订单 这一日的订单是第二天派送
  #
  # @param options [Hash]
  # @option options [Date] :date 天
  # @option options [Campus] :campus 学校
  #
  # @return [Responnse, Hash] response, orderItem Hash {'7:00': {'{specification_1}': quantity}, '7:30': ...}
  #
  def orders_at_date(options)
    deliver_time_to_specification_to_quantity_hash = {}
    response = ResponseStatus.__rescue__ do |res|
      date, campus = options[:date], options[:campus]
      res.__raise__(ResponseStatus::Code::ERROR, '缺少日期参数') if date.blank?
      res.__raise__(ResponseStatus::Code::ERROR, '缺少学校参数') if campus.blank? || !campus.is_a?(Campus)

      order_items = OrderItem.includes([{order: :payment}, {product: :store}]).references([:orders, :stores, :payments]).where('payments.id > 0 AND orders.created_at > ? AND orders.created_at < ? AND stores.id = ? AND orders.campus_id = ?', date.beginning_of_day, date.end_of_day, self.id, campus.id)

      time_keys = order_items.pluck('orders.delivery_time').uniq

      time_keys.each do |time|
        deliver_time_to_specification_to_quantity_hash[time.to_s] = order_items.where('orders.delivery_time = ?', time).group(:specification).sum(:quantity)
      end
    end

    return response, deliver_time_to_specification_to_quantity_hash
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

    # 管理者更新某店铺详情
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [String] :id 店铺id(可选)
    # @option options [Json] :store 店铺json信息(name\address\brief\logo_filename)
    # @option options [Json] :owner 店铺owner信息(contact_name\contact_phone)
    #
    # @return [Array] response, stores
    #
    def create_or_update_with_options(options = {})
      store = nil

      catch_proc = proc { store = nil }

      response = ResponseStatus.__rescue__(catch_proc) do |res|
        transaction do
          manager, id, store_json, owner_json = options[:manager], options[:id], options[:store], options[:owner]

          res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank? || store_json.blank? || owner_json.blank?

          res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

          store = manager.campus.stores.query_first_by_id(id)

          res.__raise__(ResponseStatus::Code::ERROR, '店铺不存在或不再管辖校区内') if store.blank? && id.present?

          create = false
          # Upsert
          if store.blank?
            create = true
            store = Store.new
            res.__raise__(ResponseStatus::Code::ERROR, '店铺logo不可为空') if store_json[:logo_filename].blank?
          end

          store.name = store_json[:name] if store_json[:name].present?
          store.address = store_json[:address] if store_json[:address].present?
          store.brief = store_json[:brief] if store_json[:brief].present?
          store.logo_filename = store_json[:logo_filename] if store_json[:logo_filename].present?
          store.status = store_json[:status] if store_json[:status].present?

          store.save!

          if create
            # 学校和商铺关联
            store_campus = StoresCampus.new
            store_campus.store = store
            store_campus.campus = manager.campus
            store_campus.save!

          end

          # 更新店主信息
          owner = store.owner
          if owner.blank?
            owner = Owner.new
            owner.username = "owner_#{rand(36 ** 6).to_s(36)}"
            owner.password = '123456'
          end

          owner.contact_name = owner_json[:contact_name]
          owner.contact_phone = owner_json[:contact_phone]
          owner.store = store
          owner.save!
        end
      end

      return response, store
    end

  end

end
