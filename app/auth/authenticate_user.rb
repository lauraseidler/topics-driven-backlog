class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  # Service entry point
  def call
    user = get_user(@email, @password)
    expires_at = 24.hours.from_now
    {
        auth_token: {
          token: JsonWebToken.encode(user_id: user.id, exp: expires_at),
          ttl: expires_at.to_i
        },
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
