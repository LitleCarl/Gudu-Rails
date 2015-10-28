json.partial! 'api/status', response_status: @response_status

json.data do | json |
  json.campuses do
    json.array! @data, partial: 'campuses/campus', as: :campus
  end
  json.partial! 'api/paginator'
end