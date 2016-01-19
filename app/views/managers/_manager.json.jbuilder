if manager.present?
  json.(manager, :id, :phone, :write)

  if manager.campus.present?
    json.campus do
      json.partial! 'campuses/campus', campus: manager.campus
    end
  else
    json.set! :campus, nil
  end

else
  json.nil!
end
