json.partial! 'api/status', response_status: @response_status

json.data do
  json.token @token
end