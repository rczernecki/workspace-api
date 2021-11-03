require 'rails_helper'

RSpec.describe AuthController do
  describe "#sign_up" do
    it "should return 422 error code when user param doesn't exist" do
      post signup_path, params: json_api_attributes({ some_param: "test" })
      status_unprocessable_entity
      expect(validation_errors).not_to be_nil
      expect(validation_errors[:id]).to eq("username")
      expect(validation_errors[:title]).to eq("username parameter is missing")
    end

    it "should return 400 error code when there is no auth header" do
      post signup_path, params: json_api_attributes({ username: 'testuser' })
      status_bad_request
    end

    it "should return 422 error code when username already taken" do
      user = create(:user)
      post signup_path, params: json_api_attributes({ username: user[:username] }), headers: { "Authorization": "test" }
      status_unprocessable_entity
      expect(validation_errors).not_to be_empty
      error = validation_errors.first
      expect(error[:id]).to eq("username")
      expect(error[:title]).to eq("Username has already been taken")
    end

    it "should return 401 error code when token invalid" do
      post signup_path, params: json_api_attributes({ username: "testuser" }), headers: { "Authorization": "Bearer test" }
      status_unauthorized
    end

    it 'should sign up new user' do
      uid = '0123456789012345678901234567'
      username = 'test_username'
      allow_any_instance_of(FirebaseAuthenticator)
        .to receive(:get_user_uid)
              .and_return(uid)
      post signup_path, params: json_api_attributes({ username: username }), headers: { "Authorization": "Bearer test" }
      status_created
      user = User.find_by_uid(uid)
      expect(user).not_to be_nil
      expect(user.uid).to eq(uid)
      expect(user.username).to eq(username)
      expect(user.auth_role).to eq(1)
      result = json_data
      expect(result).not_to be_nil
      check_user_json(result, user)
    end
  end

  describe "#sign_in" do
    it "should return 400 error code when there is no auth header" do
      get login_path
      status_bad_request
    end

    it "should return 401 error code when token invalid" do
      get login_path, headers: { "Authorization": "Bearer test" }
      status_unauthorized
    end

    it "should return 404 error code when token invalid" do
      uid = '0123456789012345678901234567'
      allow_any_instance_of(FirebaseAuthenticator)
        .to receive(:get_user_uid)
              .and_return(uid)
      get login_path, headers: { "Authorization": "Bearer test" }
      status_not_found
    end
  end

  describe "#refresh" do
    it "should return 401 error code when refresh token expired" do
      allow_any_instance_of(Authenticator)
        .to receive(:refresh)
              .and_raise(JWT::ExpiredSignature.new)
      post refresh_path, params: json_api_attributes({ refresh_token: "test" })
      status_unauthorized
    end

    it "should return 422 error code when there is no refresh_token param" do
      post refresh_path, params: json_api_attributes({ some_param: "test" })
      status_unprocessable_entity
      expect(validation_errors).not_to be_nil
      expect(validation_errors[:id]).to eq("refresh_token")
      expect(validation_errors[:title]).to eq("refresh_token parameter is missing")
    end
  end

  def check_user_json(given, expected)
    expect(given[:attributes].keys).to contain_exactly(:user_token, :refresh_token)
    aggregate_failures do
      expect(given[:id]).to eq(expected.uid.to_s)
      expect(given[:type]).to eq('user')
    end
  end
end

