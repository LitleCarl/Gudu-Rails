class AddressesController < ApplicationController
  def create
    @response_status, @data = Address.add_address(params)
  end

  def destroy
    @response_status, @data = Address.delete_address(params)
  end

  def update
    @response_status, @data = Address.update_address(params)
  end

end
