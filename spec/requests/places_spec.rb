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
      result = json_data.first
      aggregate_failures do
        expect(result[:id]).to eq(place.id.to_s)
        expect(result[:type]).to eq('place')
        expect(result[:attributes]).to eq(
                                         name: place.name,
                                         lat: place.lat,
                                         lon: place.lon,
                                         slug: place.slug,
                                         rating: place.rating
                                       )
      end
    end

    it 'should return places in proper order' do
      place1 = create(:place, rating: 1)
      place2 = create(:place, rating: 4)
      get '/places'
      expect(json_data.length).to eq(2)
      aggregate_failures do
        expect(json_data[0][:id]).to eq(place2.id.to_s)
        expect(json_data[1][:id]).to eq(place1.id.to_s)
      end
    end

    it 'paginates results' do
      place1, place2, place3 = create_list(:place, 3)
      get '/places', params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data[0][:id]).to eq(place2.id.to_s)
    end

    it 'contains metadata response' do
      place1, place2, place3 = create_list(:place, 3)
      get '/places', params: { page: { number: 2, size: 1 } }
      expect(json[:meta].length).to eq(3)
      expect(json[:meta].keys).to contain_exactly(
                                    :total, :total_pages, :current_page
                                  )
    end
  end

  describe 'show' do
    it 'should return a success response' do
      place = create(:place)
      get "/places/#{place.id}"
      expect(response).to have_http_status(:ok)
    end

    it 'should return a proper JSON' do
      place = create(:place)
      get "/places/#{place.id}"
      result = json_data
      aggregate_failures do
        expect(result[:id]).to eq(place.id.to_s)
        expect(result[:type]).to eq('place')
        expect(result[:attributes]).to eq(
                                         name: place.name,
                                         lat: place.lat,
                                         lon: place.lon,
                                         slug: place.slug,
                                         rating: place.rating
                                       )
      end
    end
  end
end