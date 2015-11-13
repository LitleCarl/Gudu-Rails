class AuthorizationsController < ApplicationController

  skip_before_filter :user_about

  def authorization
    @response_status, @auth = Authorization.fetch_access_token_and_open_id(params)
  end

  def weixin
    echostr = params[:echostr]
    render text: echostr
  end

end
