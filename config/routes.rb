Rails.application.routes.draw do

  ALL_REST_ACTION = [ :index, :new, :create, :show, :edit, :update, :destroy ]
  resources :addresses, param: :address_id, only: [:create, :update, :destroy ] do

  end

  resources :campuses, param: :campus_id, only: [:show, :index] do
    member do
      resources :stores,param: :store_id, only: [:index]
    end
  end

  resources :orders, param: :order_id, only: [:show, :index, :create, :show] do
    member do
      # 获取订单的支付chagre
      get :get_charge_for_unpaid_order
    end

    collection do
      get :test_print
    end
  end

  resources :users, param: :user_id, only: [:index] do
    collection do
      # 验证码登录
      post :login_with_sms_code

      # 绑定微信
      post :bind_weixin
    end

    member do
      resources :coupons, only: [:index]
    end
  end

  resources :services ,except: ALL_REST_ACTION do
    collection do
      get :get_image_form

      # 发送登录验证码
      post :send_login_sms_code

      # 基础设置
      get :basic_config

      # pingpp支付回调
      post :pingpp_pay_done

      # pingpp支付回调
      get :pingpp_pay_done

      # 随机推荐店铺
      get :random_recommend_store_in_campus

      # pingpp livemode支付回调
      post :pingpp_pay_done_for_alive

      # pingpp livemode支付回调
      get :pingpp_pay_done_for_alive

      # 搜索学校内的店铺和商品
      get :search_product_and_store_for_campus

      get :download
    end
  end

  resources :stores, param: :store_id, only: [:show]

  resources :products, param: :product_id, only: [:show]

  resources :authorizations do
    collection do
      # 微信登录
      post :authorization

      # 微信公众号开发验证
      get :weixin

      # 微信
      #get :redirect_weixin

      # 获取红包入口
      get :get_coupon
    end
  end
end
