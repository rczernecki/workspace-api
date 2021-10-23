FactoryBot.define do
  factory :place do
    sequence(:name) { |i| "Example Name #{i}" }
    lat { 51.10771151288517 }
    lon { 17.042357510153508 }
    sequence(:slug) { |i| "example-slug-#{i}" }
    rating { 0 }
  end
end
