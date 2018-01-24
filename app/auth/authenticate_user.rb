require 'net-ldap'

class AuthenticateUser
  LDAP_HOST = ENV['LDAP_HTW_HOST']
  LDAP_PORT = ENV['LDAP_HTW_PORT']
  LDAP_CONNECTSTRING = ENV['LDAP_HTW_CONNECTSTRING']
  private_constant :LDAP_PORT
  private_constant :LDAP_CONNECTSTRING
  private_constant :LDAP_HOST

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
    if email.present? && password.present?
      authenticated = authenticate_user_via_ldap(username(email), password)
      user = User.find_by(email: email)

      if user.nil? && authenticated
        user = User.create!(email: email, role: User.roles[:student]) # role needs to be set via ldap query
      end

      return user if user && authenticated
    end

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  def authenticate_user_via_ldap(username, password)
    begin
      ldap = Net::LDAP.new(
          host: LDAP_HOST,
          port: LDAP_PORT,
          encryption:
              {
                  method: :simple_tls,
                  verify_mode: OpenSSL::SSL::VERIFY_NONE
              },
          auth: {
              method: :simple,
              username: "CN=#{username},#{LDAP_CONNECTSTRING}",
              password: password
          }
      )
      ldap.bind
    rescue
      raise(ExceptionHandler::AuthenticationServerIsDown, Message.contact_the_admin)
    end
  end

  def username(email)
    m = /\A(.*)@.*htw-berlin.de\z/.match(email)
    return m[1] if m
    raise(ExceptionHandler::AuthenticationError, Message.not_htw_email(email))
  end
end
