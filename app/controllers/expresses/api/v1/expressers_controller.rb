class Expresses::Api::V1::ExpressersController <  Expresses::Api::BaseController

  skip_before_filter :authorization_filter_for_expresses

  # 送餐员登录接口
  def sign_in
    @response_status, @expresser, @token= Expresser.sign_in(params)
  end

end
