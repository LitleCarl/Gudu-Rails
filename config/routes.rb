Rails.application.routes.draw do

  ALL_REST_ACTION = [ :index, :new, :create, :show, :edit, :update, :destroy ]
  resources :addresses, param: :address_id, only: [:create, :update, :destroy ] do

  end

  resources :campuses, param: :campus_id, only: [:show, :index] do
    member do
      resources :stores,param: :store_id, only: [:index]
    end
  end

  resources :orders, param: :order_id, only: [:show, :index, :create] do
    member do
      get :get_charge_for_unpaid_order
    end
  end

  resources :users, only: [:index] do
    collection do
      post :login_with_sms_code
    end
  end
  resources :services ,except: ALL_REST_ACTION do
    collection do
      post :send_login_sms_code
      get :basic_config
      post :pingpp_pay_done
      get :pingpp_pay_done

      get :search_product_and_store_for_campus
    end

  end
  resources :stores, param: :store_id, only: [:show]
  resources :products, param: :product_id, only: [:show]
end
