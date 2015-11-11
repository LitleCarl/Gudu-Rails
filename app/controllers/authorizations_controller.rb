class AuthorizationsController < ApplicationController

  def authorization
    @response_status, @data = Address.add_address(params)
  end

end
