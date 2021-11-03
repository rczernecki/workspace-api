require 'rails_helper'

RSpec.describe '/places routes' do
  it 'routes to places#index' do
    expect(get '/places').to route_to('places#index')
  end

  it 'routes to places#show' do
    expect(get '/places/1').to route_to('places#show', id: '1')
  end

  it 'routes to places#create' do
    expect(post '/places').to route_to('places#create')
  end

  it 'routes to places#update' do
    expect(put '/places/1').to route_to('places#update', id: '1')
    expect(patch '/places/1').to route_to('places#update', id: '1')
  end

  it 'routes to places#delete' do
    expect(delete '/places/1').to route_to('places#destroy', id: '1')
  end
end