
response_status ||= @response_status

json.status do |json|

  json.code (response_status.try(:code) || ResponseStatus::Code::ERROR)
  message = response_status.try(:message)

  json.message message if message.present?

  #json.no (@no || SecureRandom.uuid)

end