json.partial! 'api/status', response_status: @response_status

json.data do | json |
  json.charge @charge
end