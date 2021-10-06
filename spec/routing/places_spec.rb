require 'rails_helper'

RSpec.describe '/places routes' do
  it 'routes to places#index' do
    aggregate_failures do
      # expect(get '/places').to route_to(controller: 'places', action: 'index')
      expect(get '/places').to route_to('places#index')
      # expect(get '/places?page[number]=3').to route_to('places#index', page: { number: 3 })
    end
  end
  it 'routes to places#show' do
    expect(get '/places/1').to route_to('places#show', id: '1')
  end
end