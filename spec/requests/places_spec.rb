require 'rails_helper'

RSpec.describe PlacesController do
  describe '#index' do
    it 'should return paginated results' do
      create_list(:place, 3)
      test_pagination(places_path, Place)
    end

    it 'should return correct json' do
      place = create(:place)
      get places_path, params: { page: { number: 1, size: 1 } }
      status_ok
      check_place_json(json_data.first, place)
    end

    it 'should return places in proper order' do
      place1 = create(:place, rating: 1)
      place2 = create(:place, rating: 4)
      get places_path
      status_ok
      expect(json_data.length).to eq(2)
      expect(json_data[0][:id]).to eq(place2.id.to_s)
      expect(json_data[1][:id]).to eq(place1.id.to_s)

    end
  end

  describe '#show' do
    it 'should return a proper JSON' do
      place = create(:place)
      get place_path(place.id)
      status_ok
      check_place_json(json_data, place)
    end

    it 'should return not found response' do
      delete place_path(1)
      status_not_found
    end
  end

  describe '#create' do
    it 'should save new entry' do
      place = build(:place)
      post places_path, params: json_api_attributes(place_attributes(place))
      status_created
      result = json_data
      expect(result).not_to be_nil
      saved_entry = Place.find(result[:id])
      check_place_json(result, saved_entry)
    end

    it 'should return an error response' do
      post places_path, params: json_api_attributes({ name: '', lat: '', lon: '' })
      status_unprocessable_entity
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
      put place_path(place.id), params: json_api_attributes({ name: new_name })
      status_ok
      expect(place.name).not_to eq(new_name)
      expect(place.reload.name).to eq(new_name)
      check_place_json(json_data, place)
    end

    it 'should return an error response' do
      place = create(:place)
      empty_name = ''
      put place_path(place.id), params: json_api_attributes({ name: empty_name })
      status_unprocessable_entity
      expect(validation_errors).not_to be_empty
      error = validation_errors.first
      expect(place.reload.name).not_to eq(empty_name)
      expect(error[:id]).to eq("name")
      expect(error[:title]).to eq("Name can't be blank")
    end

    it 'should return not found response' do
      put place_path(1), params: json_api_attributes({ name: "new name" })
      status_not_found
    end
  end

  describe '#destroy' do
    it 'should delete existing entry' do
      place = create(:place)
      delete place_path(place.id)
      status_ok
      expect { place.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should return not found response' do
      delete place_path(1)
      status_not_found
    end
  end
end

def check_place_json(given, expected)
  expect(given.keys).to contain_exactly(
                          :id, :type, :attributes
                        )
  aggregate_failures do
    expect(given[:id]).to eq(expected.id.to_s)
    expect(given[:type]).to eq('place')
    expect(given[:attributes]).to eq(
                                    name: expected.name,
                                    lat: expected.lat,
                                    lon: expected.lon,
                                    rating: expected.rating
                                  )
  end
end
