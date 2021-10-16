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

  describe '#show' do
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

  describe '#create' do
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

  describe '#update' do
    it 'should update existing entry' do
      place = create(:place)
      new_name = 'new name'
      put "/places/#{place.id}", params: { data: { attributes: { name: new_name } } }
      expect(response).to have_http_status(:ok)
      expect(place.name).not_to eq(new_name)
      expect(place.reload.name).to eq(new_name)
    end

    it 'should return an error response' do
      place = create(:place)
      empty_name = ''
      put "/places/#{place.id}", params: { data: { attributes: { name: empty_name } } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(place.reload.name).not_to eq(empty_name)
      expect(validation_errors).not_to be_empty
      error = validation_errors.first
      expect(error[:id]).to eq("name")
      expect(error[:title]).to eq("Name can't be blank")
    end

    it 'should return not found response' do
      put "/places/1", params: { data: { attributes: { name: "new name" } } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe '#destroy' do
    it 'should delete existing entry' do
      place = create(:place)
      delete "/places/#{place.id}"
      expect(response).to have_http_status(:ok)
      expect { place.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should return not found response' do
      delete "/places/1"
      expect(response).to have_http_status(:not_found)
    end
  end

end
