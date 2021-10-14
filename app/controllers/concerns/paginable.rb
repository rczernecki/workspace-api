module Paginable
  extend ActiveSupport::Concern

  def render_paginated_collection(collection)
    paginated = collection.page(params[:page]['number'] || 1).per(params[:page]['size'] || limit_value)
    options = { meta: meta(paginated) }
    render json: serializer.new(paginated, options), status: :ok
  end

  def pagination_params_exists
    params[:page].present? and (params[:page]['number'].present? or params[:page]['size'].present?)
  end

  private

  def meta(paginated)
    {
      total: paginated.total_count,
      total_pages: paginated.total_pages,
      current_page: paginated.current_page
    }
  end

  def base_url
    request.base_url + request.path
  end
end