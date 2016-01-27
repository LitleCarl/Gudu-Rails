class Management::OrdersController < Management::ManagementBaseController

  # 管理者获取自身校区的订单
  def index
    @response, @orders = Order.query_orders_for_management(params)
  end

end
