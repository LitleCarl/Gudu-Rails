
json.(campus, :id, :name, :logo_filename, :address, :location)
# has_many
# json.stores do | json |
#   json.array! campus.stores, partial: 'stores/store', as: :store
# end
# belongs_to
json.city_id campus.city_id
