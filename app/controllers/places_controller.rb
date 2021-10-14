class PlacesController < ApplicationController
  include Paginable

  def index
    if pagination_params_exists
      render_paginated_collection(Place.by_rating_desc)
    else
      render json: serializer.new(Place.by_rating_desc), status: :ok
    end
  end

  def show
    render json: serializer.new(Place.find(params[:id])), status: :ok
  end

  def serializer
    PlaceSerializer
  end
end