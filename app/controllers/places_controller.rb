class PlacesController < ApplicationController
  include Paginable, ErrorSerializer

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

  def create
    place = Place.new(place_params)
    if place.save
      render json: serializer.new(place), status: :created
    else
      render json: ErrorSerializer.serialize(place.errors), status: :unprocessable_entity
    end
  end

  def update
    begin
      place = Place.find(params[:id])
    rescue
      render nothing: true, status: :not_found
    else
      if place.update(place_params)
        render json: serializer.new(place), status: :ok
      else
        render json: ErrorSerializer.serialize(place.errors), status: :unprocessable_entity
      end
    end
  end

  def place_params
    params.require(:data).require(:attributes).permit(:name, :lat, :lon, :slug)
  end

  def serializer
    PlaceSerializer
  end
end