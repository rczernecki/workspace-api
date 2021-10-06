class Place < ApplicationRecord
  validates :name, presence: true
  validates :lat, presence: true
  validates :lon, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  scope :by_rating_desc, -> { order(rating: :desc) }
end
