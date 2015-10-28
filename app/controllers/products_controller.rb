class ProductsController < ApplicationController
  skip_before_filter :user_about
  def show
    @response_status, @product = Product.get_product_detail_by_id(params)
  end
end
