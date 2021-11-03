class Authenticator
  class MissingAuthHeaderError < StandardError; end

  def initialize
    @firebase_authenticator = FirebaseAuthenticator.new
  end

  def sign_up(request, username)
    ext_user_token = fetch_bearer_token(request)
    if username_exists(username)
      raise Exceptions::ValidationError.new([{ "id": "username", "title": "Username has already been taken" }])
    end
    uid = @firebase_authenticator.get_user_uid(ext_user_token)
    user = User.create!(uid: uid, username: username)
    UserTo.new(uid, generate_user_token(user), generate_refresh_token(uid))
  end

  def sign_in(request)
    ext_user_token = fetch_bearer_token(request)
    uid = @firebase_authenticator.get_user_uid(ext_user_token)
    user = User.find_by_uid!(uid)
    UserTo.new(uid, generate_user_token(user), generate_refresh_token(uid))
  end

  def refresh(refresh_token)
    uid = decode_refresh_token(refresh_token)
    user = User.find_by_uid(uid)
    UserTo.new(uid, generate_user_token(user), generate_refresh_token(uid))
  end

  #returns { :uid, :username, :role } based on bearer token
  def authenticate(request)
    decode_user_token(fetch_bearer_token(request))
  end

  private

  def fetch_bearer_token(request)
    authorization = request.headers['Authorization']
    if authorization.nil?
      raise MissingAuthHeaderError.new
    end
    authorization.split(' ').last
  end

  def username_exists(username)
    User.find_by_username(username).present?
  end

  def generate_user_token(user)
    token_invalid_after = 900 #15 min
    expiration_date = Time.now.to_i + token_invalid_after
    payload = { uid: user[:uid], username: user[:username], role: user[:role], exp: expiration_date }
    JWT.encode payload, Rails.application.credentials[:jwt_secret], 'HS256'
  end

  #returns { :uid, :username, :role }
  def decode_user_token(user_token)
    JWT.decode(
      user_token,
      Rails.application.credentials[:jwt_secret],
      true,
      { algorithm: 'HS256' }
    )[0][:uid, :username, :role]
  end

  def generate_refresh_token(uid)
    token_invalid_after = 2678400 #31 days
    expiration_date = Time.now.to_i + token_invalid_after
    payload = { uid: uid, exp: expiration_date }
    JWT.encode payload, Rails.application.credentials[:jwt_secret], 'HS256'
  end

  #returns uid
  def decode_refresh_token(refresh_token)
    JWT.decode(
      refresh_token,
      Rails.application.credentials[:jwt_secret],
      true,
      { algorithm: 'HS256' }
    )[0][:uid]
  end
end