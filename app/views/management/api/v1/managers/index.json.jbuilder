json.partial! 'api/status', response_status: @response_status
json.data do | json |
  json.manager do
    json.partial! 'managers/manager', manager: @manager
  end
end
