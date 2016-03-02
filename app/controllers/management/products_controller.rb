class Management::ProductsController < Management::ManagementBaseController

  # 管理者获取商铺的商品列表
  def index
    @response, @store, @products = Product.query_store_products_for_management(params)
  end

  # 管理者查看商品详情
  def show
    @response, @store, @product = Product.query_product_for_management(params)
  end

  # 管理者更新商品详情
  def update
    @response, @store, @product = Product.create_or_update_product_for_management(params)
    if @response.is_successful?
      @response.message = '请刷新页面'
    end
  end

  # 管理者添加商品详情
  def create
    @response, @store, @product = Product.create_or_update_product_for_management(params)
  end

  def new
  end
end
