json.partial! 'api/status', response_status: @response_status
json.data do
  json.update_info @update_info
end