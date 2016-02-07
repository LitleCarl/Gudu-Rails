if user.present?
  render_json_attrs(json, user, [:id, :phone, :avatar])
  json.addresses do
    json.array! user.addresses, partial: 'addresses/address', as: :address
  end
else
  json.nil!
end
