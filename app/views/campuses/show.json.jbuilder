json.partial! 'api/status', response_status: @response_status

json.data do | json |
  json.campus do
    json.partial! @data, partial: 'campuses/campus', as: :campus
  end
end