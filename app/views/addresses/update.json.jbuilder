json.partial! "api/status", response_status: @response_status

json.data do | json |
  json.address do | json |
    json.partial! "addresses/address", address: @data
  end
end