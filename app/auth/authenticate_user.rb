# https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-two

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
    # todo authenticate via LDAP, return nil if LDAP Auth fails
    if password.empty?
      raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end
    if User.find_by(email: email).present?
      user = User.find_by(email: email)
    else
      user = User.create!([:email => email])
    end

    return user if user
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
