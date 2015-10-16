if user.present?
  json.(user, :id, :phone)
  json.addresses do
    json.array! user.addresses, partial: 'addresses/address', as: :address
  end
else
  json.nil!
end
