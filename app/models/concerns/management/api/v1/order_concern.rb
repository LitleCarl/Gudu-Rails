# encoding: utf-8

module Concerns::Management::Api::V1::OrderConcern

  extend ActiveSupport::Concern

  included do
    # 通用查询方法
    include Concerns::Query::Methods
  end

  module ClassMethods

    # 管理者查询该学校的订单
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [Integer] :id 状态(可选)
    #
    # @return [Array] response, coupon
    #
    def add_print_count_by_one(options = {})
      response = ResponseStatus.__rescue__ do |res|
        manager, order_id, status = options[:manager], options[:id]

        order = Order.query_first_by_id(order_id)

        res.__raise__(ResponseStatus::Code::ERROR, '订单不存在') if order.blank?

        order.print_count = (order.print_count || 0) + 1
        order.save!
      end

      return response
    end

    # 管理者查询该学校的订单
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [Date] :date 日期(可选)
    # @option options [Status] :status 状态(可选)
    # @option options [Integer] :page 状态(可选)
    # @option options [Integer] :limit 状态(可选)
    #
    # @return [Array] response, coupon
    #
    def query_orders_for_management(options = {})
      orders = []

      catch_proc = proc{
        orders = []
      }

      response = ResponseStatus.__rescue__(catch_proc) do |res|

        manager, date, status = options[:manager], options[:date], options[:status]

        if date.present?
          date = Date.parse(date)
        else
          date = Time.now
        end
        res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank?

        res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

        orders = self.query_by_options.includes(:order_items => {specification: :product}).joins(:payment).where('payments.id > 0 and orders.campus_id = ?', manager.campus.id).where('orders.created_at >= ? AND orders.created_at <= ?', date.beginning_of_day, date.end_of_day)

        if status.present?
          orders = orders.where(status: status)
        else
          orders = orders.where(status: Order::Status::PAYMENT_SUCCESS)
        end

        # 分页
        #orders = orders.page(options[:page]).per(options[:limit])

        # 排序
        orders = orders.order('orders.created_at desc')
      end

      return response, orders
    end
  end

end
