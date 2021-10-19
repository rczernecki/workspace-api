require 'rails_helper'

RSpec.describe Place, type: :model do
  let(:place) { create(:place) }

  describe '#validations' do
    it 'tests model factory' do
      expect(place).to be_valid
    end

    it 'tests name validation' do
      place.name = nil
      check_expected_validation_errors(place, [:blank])
      place.name = ' '
      check_expected_validation_errors(place, [:blank])
      place.name = 'x'
      expect(place).to be_valid
      place.name = SecureRandom.uuid[0..29]
      expect(place).to be_valid
      place.name = SecureRandom.uuid[0..30]
      check_expected_validation_errors(place, [:too_long])
    end

    it 'tests lat validation' do
      place.lat = nil
      check_expected_validation_errors(place, [:blank, :not_a_number])
      place.lat = -90.1
      check_expected_validation_errors(place, [:greater_than_or_equal_to])
      place.lat = -90
      expect(place).to be_valid
      place.lat = 0
      expect(place).to be_valid
      place.lat = 90
      expect(place).to be_valid
      place.lat = 90.1
      check_expected_validation_errors(place, [:less_than_or_equal_to])
    end

    it 'tests lon validation' do
      place.lon = nil
      check_expected_validation_errors(place, [:blank, :not_a_number])
      place.lon = -180.1
      check_expected_validation_errors(place, [:greater_than_or_equal_to])
      place.lon = -180
      expect(place).to be_valid
      place.lon = 0
      expect(place).to be_valid
      place.lon = 180
      expect(place).to be_valid
      place.lon = 180.1
      check_expected_validation_errors(place, [:less_than_or_equal_to])
    end

    it 'tests slug validation' do
      place1 = FactoryBot.build(:place, slug: place.slug)
      check_expected_validation_errors(place1, [:taken])
      place.slug = nil
      check_expected_validation_errors(place, [:blank])
      place.slug = ' '
      check_expected_validation_errors(place, [:blank])
      place.slug = 'x'
      expect(place).to be_valid
      place.slug = SecureRandom.uuid[0..32]
      expect(place).to be_valid
      place.slug = SecureRandom.uuid[0..33]
      check_expected_validation_errors(place, [:too_long])
    end

    it 'tests rating validation' do
      place.rating = nil
      check_expected_validation_errors(place, [:blank, :not_a_number])
      place.rating = -1
      check_expected_validation_errors(place, [:greater_than_or_equal_to])
      place.rating = 0
      expect(place).to be_valid
      place.rating = 5
      expect(place).to be_valid
      place.rating = 6
      check_expected_validation_errors(place, [:less_than_or_equal_to])
    end

  end

  describe '.by_rating_desc' do
    it 'should return places in proper order' do
      place2 = create(:place, rating: 4)

      expect(described_class.by_rating_desc).to eq(
                                                  [place2, place]
                                                )
      place.update_column(:rating, 5)
      expect(described_class.by_rating_desc).to eq(
                                                  [place, place2]
                                                )
    end
  end
end
