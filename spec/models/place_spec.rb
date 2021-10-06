require 'rails_helper'

RSpec.describe Place, type: :model do

  it 'tests place object' do
    # article = Place.create({name: 'Etno OVO Cafe', lat: 51.10771151288517, lon: 17.042357510153508})
    # article = FactoryBot.create(:place)
    place = create(:place) # create is included via rails_helper
    expect(place.name).to eq("Etno OVO Cafe")
  end

  describe '#validations' do
    let(:place) { create(:place) }

    it 'tests that place object is valid' do
      expect(place).to be_valid #place.valid? == true
    end

    it 'has the invalid name' do
      #build doesn't persist the record as create do. Active record validations won't be run.
      place.name = ''
      expect(place).not_to be_valid
      expect(place.errors[:name]).to include("can't be blank")
    end
  end

end
