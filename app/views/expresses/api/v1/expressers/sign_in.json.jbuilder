json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @token
    json.token @token
  end
  json.expresser do
    if @expresser.present?
      json.partial! 'expressers/expresser', expresser:  @expresser
    else
      json.nil!
    end
  end
end