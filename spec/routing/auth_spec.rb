require 'rails_helper'

RSpec.describe('/auth routes') do
  it('routes to auth/signup') do
    expect(post '/auth/signup').to route_to('auth#sign_up')
  end

  it('routes to auth/login') do
    expect(get '/auth/login').to route_to('auth#login')
  end

  it('routes to auth/refresh') do
    expect(post '/auth/refresh').to route_to('auth#refresh')
  end
end