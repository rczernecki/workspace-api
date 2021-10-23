require "active_support/concern"
require 'kaminari'

module Paginable
  extend ActiveSupport::Concern

  def render_paginated_collection(collection)
    paginated = collection.page
    parameters = pagination_params
    unless parameters[:page].nil?
      paginated = collection.page(parameters[:page][:number]).per(parameters[:page][:size])
    end
    options = paginated.total_count == 0 ? { meta: meta(paginated) } : { meta: meta(paginated), links: links(paginated) }
    render json: serializer.new(paginated, options), status: :ok
  end

  private

  def meta(paginated)
    meta_hash = {
      total: paginated.total_count,
      total_pages: paginated.total_pages
    }
    unless paginated.total_count == 0
      meta_hash = meta_hash.merge current_page: paginated.current_page
      meta_hash = meta_hash.merge per_page: paginated.limit_value
    end
    meta_hash
  end

  def links(paginated)
    links_hash = {
      first: "#{base_url}?page[number]=1&page[size]=#{paginated.limit_value}",
      last: "#{base_url}?page[number]=#{paginated.total_pages}&page[size]=#{paginated.limit_value}"
    }
    if paginated.current_page != 1 && paginated.current_page <= paginated.total_pages + 1
      links_hash = links_hash.merge prev: "#{base_url}?page[number]=#{paginated.current_page - 1}&page[size]=#{paginated.limit_value}"
    end
    if paginated.current_page < paginated.total_pages
      links_hash = links_hash.merge next: "#{base_url}?page[number]=#{paginated.current_page + 1}&page[size]=#{paginated.limit_value}"
    end
    links_hash
  end

  def base_url
    request.base_url + request.path
  end

  def pagination_params
    params.permit(page: [:number, :size])
  end
end