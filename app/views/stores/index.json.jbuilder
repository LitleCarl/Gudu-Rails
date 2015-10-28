json.partial! 'api/status', response_status: @response_status

json.data do | json |
  json.stores do
    json.array! @stores, partial: 'stores/store', as: :store
  end
  json.partial! 'api/paginator'
end