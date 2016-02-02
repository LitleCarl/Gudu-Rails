class Management::ProductsController < Management::ManagementBaseController

  # 管理者获取商铺的商品列表
  def index
    @response, @store, @products = Product.query_store_products_for_management(params)
  end

end
