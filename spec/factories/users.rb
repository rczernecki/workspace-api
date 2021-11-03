FactoryBot.define do
  factory :user do
    sequence(:uid) { |i| "012345678901234567890123456#{i}" }
    sequence(:username) { |i| "username#{i}" }
    auth_role { 1 }
  end
end
