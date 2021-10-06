class PlaceSerializer
  include JSONAPI::Serializer
  set_type :place
  attributes :name, :lat, :lon, :slug, :rating
end
