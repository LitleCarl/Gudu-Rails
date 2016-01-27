class Expresses::Api::V1::ExpressersController <  Expresses::Api::BaseController

  skip_before_filter :authorization_filter_for_expresses, only: [:sign_in]

  # 送餐员登录接口
  def sign_in
    @response_status, @expresser, @token= Expresser.sign_in(params)
  end

  # 送餐员绑定订单
  def bind_order
    @response_status= Expresser.bind_order(params)
  end

end
