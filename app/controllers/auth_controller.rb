class AuthController < ApplicationController

  def initialize
    @authenticator = Authenticator.new
  end

  rescue_from FirebaseAuthenticator::InvalidTokenError do
    render nothing: true, status: :unauthorized
  end

  def sign_up
    user_to = @authenticator.sign_up(request, signup_params)
    render json: serializer.new(user_to), status: :created
  end

  def login
    user_to = @authenticator.sign_in(request)
    render json: serializer.new(user_to), status: :ok
  end

  def refresh
    begin
      user_to = @authenticator.refresh(refresh_params)
      render json: serializer.new(user_to), status: :ok
    end
  end

  private

  def signup_params
    params.require(:data).require(:attributes).require(:username)
  end

  def refresh_params
    params.require(:data).require(:attributes).require(:refresh_token)
  end

  def serializer
    UserToSerializer
  end
end
