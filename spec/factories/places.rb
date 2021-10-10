require 'securerandom'

FactoryBot.define do
  factory :place do
    name { 'Example Name' }
    lat { 51.10771151288517 }
    lon { 17.042357510153508 }
    slug { SecureRandom.uuid[0..32] }
    rating { 0 }
  end
end
