json.partial! 'api/status', response_status: @response_status
json.data do
  json.store do
    if @store.present?
      json.partial! @store, partial: 'stores/store', as: :store
    else
      json.nil!
    end
  end
end