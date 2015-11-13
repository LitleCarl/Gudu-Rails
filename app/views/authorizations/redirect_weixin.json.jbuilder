json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @auth.present?
    json.auth do
      json.partial! @auth, partial: 'authorizations/authorization', as: :authorization
    end
  else
    json.auth nil
  end
end