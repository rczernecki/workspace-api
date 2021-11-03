require 'jsonapi/serializer'

class PlaceSerializer
  include JSONAPI::Serializer
  attributes :name, :lat, :lon, :rating
end
