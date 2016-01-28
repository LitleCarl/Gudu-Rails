json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @token
    json.token @token
  end
  json.manager do
    if @manager.present?
      json.partial! 'managers/manager', manager: @manager
    else
      json.nil!
    end
  end
end