require 'net/http'

class FirebaseAuthenticator
  class InvalidTokenError < StandardError; end

  def get_firebase_user_data(firebase_user_token)
    if firebase_user_token.nil?
      raise InvalidTokenError.new
    end
    uri = URI.parse("https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=#{Rails.application.credentials[:firebase_key]}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    user_data = JSON.parse(http.post(uri.request_uri, { "idToken" => firebase_user_token }.to_json, "Content-Type" => "application/json").body)
    if user_data["error"].present?
      raise InvalidTokenError.new
    end
    user_data["users"].first
  end

  def get_user_uid(firebase_user_token)
    firebase_user = get_firebase_user_data(firebase_user_token)
    firebase_user["localId"]
  end
end

