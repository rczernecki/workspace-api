class PlaceSerializer
  include JSONAPI::Serializer
  attributes :name, :lat, :lon, :slug, :rating
end
