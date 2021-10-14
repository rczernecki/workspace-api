class PlacesController < ApplicationController
  include Paginable

  def index
    if pagination_params_exists
      render_paginated_collection(Place.by_rating_desc)
    else
      render json: PlaceSerializer.new(Place.by_rating_desc), status: :ok
    end
  end

  def serializer
    PlaceSerializer
  end

end