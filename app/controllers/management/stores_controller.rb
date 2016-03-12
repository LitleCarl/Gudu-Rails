class Management::StoresController < Management::ManagementBaseController

  # 管理者获取自身校区的订单
  def index
    @response, @stores = Store.query_for_management(params)
  end

  def show
    @response, @store = Store.query_detail_for_management(params)
  end

  def update
    @response, @store = Store.create_or_update_with_options(params)
  end

  def new

  end

  def create
    @response, @store = Store.create_or_update_with_options(params)
  end

end
