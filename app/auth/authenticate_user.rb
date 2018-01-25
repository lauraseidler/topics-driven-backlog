class AuthenticateUser
  include DomainDefinition

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
      ldap_user_role = LdapAuthenticator.new(username(email), password).call
      user = User.find_by(email: email)

      if user.nil?
        user = User.create!(email: email, role: ldap_user_role)
      elsif user.role != ldap_user_role
        user.update_attribute(:role, ldap_user_role)
      end

      return user if user
    end

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  def username(email)
    m = /\A(.*)@.*#{DomainDefinition::ORGANISATION_DOMAIN}\z/.match(email)
    return m[1] if m
    raise(ExceptionHandler::AuthenticationError, Message.not_domain_email_address(email))
  end
end
