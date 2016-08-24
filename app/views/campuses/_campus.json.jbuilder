render_json_attrs(json, campus, [:id, :name, :logo_filename, :address, :location, :first_letter])
# has_many

json.places campus.places.map {|place| place.name}

# belongs_to
json.city_id campus.city_id
