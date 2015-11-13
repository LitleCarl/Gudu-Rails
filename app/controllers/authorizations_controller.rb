class AuthorizationsController < ApplicationController

  skip_before_filter :user_about

  # ios/android登录回调
  def authorization
    @response_status, @auth = Authorization.fetch_access_token_and_open_id(params)
  end

  # 公众号获取用户信息,微信浏览器redirect的action
  def redirect_weixin
    @response_status, @auth = Authorization.fetch_access_token_and_open_id_by_weixin_client(params)
  end

  def weixin
    echostr = params[:echostr]
    render text: echostr
  end

end
