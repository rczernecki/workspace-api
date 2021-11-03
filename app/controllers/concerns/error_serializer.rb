module ErrorSerializer

  def ErrorSerializer.serialize_model_errors(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash(true).map do |k, v|
      v.map do |msg|
        { id: k, title: msg }
      end
    end
    json[:errors] = new_hash.flatten
    json
  end

  def ErrorSerializer.serialize_errors(errors)
    return if errors.nil?

    json = {}
    json[:errors] = errors.flatten
    json
  end

end