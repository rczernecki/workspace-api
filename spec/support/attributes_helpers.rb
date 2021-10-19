module AttributesHelpers
  def trim_application_record_attributes(application_record)
    application_record.attributes.except('id', 'created_at', 'updated_at')
  end

  def place_attributes(place)
    params = trim_application_record_attributes(place)
    params.except('rating')
  end
end