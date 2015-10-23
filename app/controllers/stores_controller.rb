class StoresController < ApplicationController
  skip_before_filter :user_about
  def index
    @response_status, @stores= Store.get_stores_in_campus(params)
  end

  def show
    @response_status, @store = Store.get_store_by_id(params)
  end

end
