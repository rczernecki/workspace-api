class UserTo

  def initialize(id, user_token, refresh_token)
    @id = id
    @user_token = user_token
    @refresh_token = refresh_token
  end

  attr_accessor :id, :user_token, :refresh_token
end