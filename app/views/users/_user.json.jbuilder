if user.present?
  render_json_attrs(json, user, [:id, :phone, :avatar])

  if user.avatar.blank?
    json.avatar 'http://7xnsaf.com1.z0.glb.clouddn.com/avatar.jpg'
  end

  json.addresses do
    json.array! user.addresses, partial: 'addresses/address', as: :address
  end
else
  json.nil!
end
