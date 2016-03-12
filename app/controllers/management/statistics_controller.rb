class Management::StatisticsController < Management::ManagementBaseController

  # 管理者获取自身校区的店铺的商品统计
  def index
    @response, @stores_time_to_order_array, @campus = Campus.statistic_for_date(params)
  end

end
