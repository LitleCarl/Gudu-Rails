class OrdersController < ApplicationController

=begin
@api {get} /orders 获取用户订单列表
@apiName GetOrders
@apiGroup Order

@apiParam {Number} [page=1]     Optional page with default 1.
@apiParam {Number} [limit=8]     Optional limit with default 8.

@apiSuccess {Array}  orders 订单列表
@apiSuccess {Number} page  页数
@apiSuccess {Number} limit 每页数量
=end

  def index
    @response_status, @orders, @page, @limit= Order.get_orders_of_user(params)
  end

=begin
@api {get} /orders/charge_for_order 获得未付款订单的charge
@apiName GetOrderCharge
@apiGroup Order

@apiParam {String} order_id     订单id

@apiSuccess {String}  charge 订单关联的charge
=end
  def get_charge_for_unpaid_order
    @response_status, @charge = Order.get_charge_for_unpaid_order(params)
  end
end
