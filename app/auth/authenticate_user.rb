class AuthenticateUser
  def initialize(email, password)
    @email = email
    @password = password
  end

  # Service entry point
  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_reader :email, :password

  # verify user credentials
  def user
    if password.empty?
      user = nil
    else
      user = User.find_by(email: email)
    end

    return user if user
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
