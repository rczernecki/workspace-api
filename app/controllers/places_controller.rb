class PlacesController < ApplicationController
  def index
    places = Place.by_rating_desc
    render json: serializer.new(places), status: :ok
  end

  def serializer
    PlaceSerializer
  end
end