class User < ApplicationRecord
  attribute :auth_role, :integer, default: 1
  validates :uid, presence: true, uniqueness: true, length: { is: 28 }
  validates :username, presence: true, uniqueness: true, length: { in: 1..20 }
  validates :auth_role, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

end
