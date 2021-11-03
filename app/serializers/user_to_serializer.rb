require 'jsonapi/serializer'

class UserToSerializer
  include JSONAPI::Serializer
  set_type :user
  set_id :id
  attributes :user_token, :refresh_token
end

