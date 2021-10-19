module ApiHelpers
  def json
    JSON.parse(response.body).deep_symbolize_keys
  end

  def json_data
    json[:data]
  end

  def validation_errors
    json[:errors]
  end

  def json_api_attributes(attributes)
    { data: { attributes: attributes } }
  end

  def status_ok
    expect(response).to have_http_status(:ok)
  end

  def status_unprocessable_entity
    expect(response).to have_http_status(:unprocessable_entity)
  end

  def status_not_found
    expect(response).to have_http_status(:not_found)
  end

  def status_created
    expect(response).to have_http_status(:created)
  end
end