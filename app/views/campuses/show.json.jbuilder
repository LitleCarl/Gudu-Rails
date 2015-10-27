json.partial! 'api/status', response_status: @response_status

json.data do | json |
  if @data.present?
    json.campus do
      json.partial! @data, partial: 'campuses/campus', as: :campus
    end
  else
    json.campus nil
  end
end