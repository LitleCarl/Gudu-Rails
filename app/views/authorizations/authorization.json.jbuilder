json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @auth.present?
    json.auth do
      json.partial! @auth, partial: 'authorizations/authorization', as: :authorization
    end
  else
    json.auth nil
  end


  if @token
    json.token @token
  else
    json.token nil
  end

  json.user do
    if @user.present?
      json.partial! @user, partial: 'users/user', as: :user
    else
      json.nil!
    end
  end
end