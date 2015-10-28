json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @token
    json.token @token
  end
  json.user do
    if @user.present?
      json.partial! @user, partial: 'users/user', as: :user
    else
      json.nil!
    end
  end
end