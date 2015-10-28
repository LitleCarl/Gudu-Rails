json.partial! 'api/status', response_status: @response_status
json.data do | json |
  json.user do
      json.partial! @user, partial: 'users/user', as: :user
  end
end
