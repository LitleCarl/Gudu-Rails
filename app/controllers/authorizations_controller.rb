class AuthorizationsController < ApplicationController

  def authorization
    @response_status, @auth = Authorization.fetch_access_token_and_open_id(params)
  end

end
