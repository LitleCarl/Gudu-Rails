json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @token
    json.token @token
  end
  json.manager do
    if @manager.present?
      json.partial! @manager, partial: 'managers/manager', as: :manager
    else
      json.nil!
    end
  end
end