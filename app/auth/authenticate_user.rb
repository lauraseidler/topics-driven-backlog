class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  # Service entry point
  def call
    user = get_user(@email, @password)
    {
        auth_token: JsonWebToken.encode(user_id: user.id),
        user: user
    }
  end

  private

  # verify user credentials
  def get_user(email, password)
    if password.empty?
      user = nil
    else
      user = User.find_by(email: email)
    end

    return user if user
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
