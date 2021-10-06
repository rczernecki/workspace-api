require 'rails_helper'

RSpec.describe PlacesController do
  describe '#index' do
    it 'should return success response' do
      get '/places'
      expect(response).to have_http_status(:ok)
    end

    it 'should return a propper JSON' do
      place = create :place
      get '/places'
      expect(json_data.length).to eq(1)
      expected = json_data.first
      aggregate_failures do
        expect(expected[:id]).to eq(place.id.to_s)
        expect(expected[:type]).to eq('place')
        expect(expected[:attributes]).to eq(
                                           name: place.name,
                                           lat: place.lat,
                                           lon: place.lon,
                                           slug: place.slug
                                         )

      end
    end

    it 'should return places in proper order' do
      place1 = build :place
      place1.rating = 1
      place1.save
      place2 = build :place
      place2.rating = 5
      place2.save

      get '/places'
      expect(json_data.length).to eq(2)
      aggregate_failures do
        expect(json_data.first[:id]).to eq(place2.id.to_s)
        expect(json_data[1][:id]).to eq(place1.id.to_s)

      end
    end
  end
end