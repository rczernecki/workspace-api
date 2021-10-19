class PlacesController < ApplicationController
  include Paginable

  def index
    render_paginated_collection(Place.by_rating_desc)
  end

  def show
    render json: serializer.new(Place.find(params[:id])), status: :ok
  end

  def create
    render json: serializer.new(Place.create!(place_params)), status: :created
  end

  def update
    place = Place.find(params[:id])
    place.update!(place_params)
    render json: serializer.new(place), status: :ok
  end

  def destroy
    Place.destroy(params[:id])
    render nothing: true, status: :ok
  end

  def place_params
    params.require(:data).require(:attributes).permit(:name, :lat, :lon, :slug)
  end

  def serializer
    PlaceSerializer
  end
end