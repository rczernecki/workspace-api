class ApplicationController < ActionController::API
  include ErrorSerializer

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { errors: { id: exception.param, title: "#{exception.param} parameter is missing" } }, status: :unprocessable_entity
  end

  rescue_from ActionController::UnpermittedParameters do |exception|
    errors_table = exception.params.map do |param|
      { id: param, title: "found unexpected parameter #{param}" }
    end
    render json: { errors: errors_table }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do
    render nothing: true, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: ErrorSerializer.serialize(exception.record.errors), status: :unprocessable_entity
  end
end
