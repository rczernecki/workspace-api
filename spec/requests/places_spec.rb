require 'rails_helper'

RSpec.describe PlacesController do
  describe '#index' do
    it 'should return places in proper order' do
      place1 = create(:place, rating: 1)
      place2 = create(:place, rating: 4)
      get '/places'
      expect(response).to have_http_status(:ok)
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
    it 'should return a proper JSON' do
      place = create(:place)
      get "/places/#{place.id}"
      expect(response).to have_http_status(:ok)
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

  describe 'create' do
    it 'should save new entry' do
      place = build(:place)
      post '/places', params: { data: { attributes: place.attributes } }
      expect(response).to have_http_status(:created)
      result = json_data
      expect(result).not_to be_nil
      saved_entry = Place.find(result[:id])
      expect(saved_entry).not_to be_nil

    end

    it 'should return an error response' do
      post '/places', params: { data: { attributes: { name: '', lat: '', lon: '', slug: '' } } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(validation_errors).not_to be_empty
      error = validation_errors.first
      expect(error[:id]).to eq("name")
      expect(error[:title]).to eq("Name can't be blank")
    end
  end
end
