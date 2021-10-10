module ValidationHelpers
  def check_expected_validation_errors (validated_object, types)
    expect(validated_object).not_to be_valid
    current_types = validated_object.errors.objects.map { |error| error.raw_type }
    types.each { |type| expect(current_types).to include(type) }
  end
end