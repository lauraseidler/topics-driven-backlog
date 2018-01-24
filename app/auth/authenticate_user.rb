require 'net-ldap'

class AuthenticateUser
  LDAP_HOST = ENV['LDAP_HTW_HOST']
  LDAP_PORT = ENV['LDAP_HTW_PORT']
  LDAP_CONNECTSTRING = ENV['LDAP_HTW_CONNECTSTRING']
  HTW_USER_TYPE_STUDENT = 'student'
  HTW_USER_TYPE_INSTRUCTOR = 'lehrende'

  private_constant :LDAP_PORT
  private_constant :LDAP_CONNECTSTRING
  private_constant :LDAP_HOST
  private_constant :HTW_USER_TYPE_STUDENT
  private_constant :HTW_USER_TYPE_INSTRUCTOR

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
      user_role = get_user_role_via_ldap(username(email), password)
      user = User.find_by(email: email, role: user_role)

      if user.nil?
        # TODO set role if user_role changed on ldap
        user = User.create!(email: email, role: user_role)
      end

      return user if user
    end

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  def get_user_role_via_ldap(username, password)
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
    rescue
      raise(ExceptionHandler::AuthenticationServerIsDown, Message.contact_the_admin)
    end

    authenticate_user_via_ldap(ldap)
    get_user_role(ldap, username)
  end

  def authenticate_user_via_ldap(ldap)
    authenticated = ldap.bind

    return authenticated if authenticated
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  def get_user_role(ldap, username)
    filter = Net::LDAP::Filter.eq( "CN", "#{username}" )
    query_result = ldap.search( :base => LDAP_CONNECTSTRING, :filter => filter )

    if query_result.size != 1
      raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end

    user_groups = query_result[0]['memberof'].split(',')

    user_groups.split('=').each do |group, value|
      if group == 'DN' && value == HTW_USER_TYPE_INSTRUCTOR
        return User.roles[:instructor]
      end

      if group == 'DN' && value == HTW_USER_TYPE_STUDENT
        return User.roles[:student]
      end
    end

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  def username(email)
    m = /\A(.*)@.*htw-berlin.de\z/.match(email)
    return m[1] if m
    raise(ExceptionHandler::AuthenticationError, Message.not_htw_email(email))
  end
end
