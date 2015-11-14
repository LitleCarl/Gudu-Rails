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

  # 客户获取优惠券的action
  def get_coupon
    @response_status, @red_pack, @frozen_coupon = Authorization.get_frozen_coupon_by_weixin_authorization(params)
    @red_pack ||= RedPack.all.first
    puts "我的@response_status:#{@response_status}"
  end

  # 公众号验证开发者
  def weixin
    render text: params[:echostr]
  end

end
