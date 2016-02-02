class Management::StatisticsController < Management::ManagementBaseController

  # 管理者获取自身校区的店铺的商品统计
  def index
    @response, @orders = Order.query_orders_for_management(params)
  end

end
