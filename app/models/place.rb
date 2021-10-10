class Place < ApplicationRecord
  attribute :rating, :integer, default: 0
  validates :name, presence: true, length: { in: 1..30 }
  validates :lat, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lon, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :slug, presence: true, uniqueness: true, length: { in: 1..33 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  scope :by_rating_desc, -> { order(rating: :desc) }
end
