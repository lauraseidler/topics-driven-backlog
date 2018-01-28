require 'net-ldap'

class LdapAuthenticator

  # Returns the user role of an user if this user was authenticated via ldap
  def initialize(username, password)
    @username = username
    @password = password
  end

  def call
    get_user_role(connect_to_ldap(@username, @password))
  end

  private

  def connect_to_ldap(username, password)
    query_result = []
    begin
      Net::LDAP.open(
          host: DomainDefinition::LDAP_HOST,
          port: DomainDefinition::LDAP_PORT,
          encryption:
              {
                  method: :simple_tls,
                  verify_mode: OpenSSL::SSL::VERIFY_NONE
              },
          auth: {
              method: :simple,
              username: "CN=#{username},#{DomainDefinition::LDAP_CONNECTSTRING}",
              password: password
          }
      ) do |ldap|
        query_result = ldap.search(
            :base => DomainDefinition::LDAP_CONNECTSTRING,
            :filter => Net::LDAP::Filter.eq('CN', username)
        )
        Rails.logger.info "LDAP Connection: #{ldap.get_operation_result.message}"
      end
      return query_result
    rescue Errno::ECONNREFUSED => e
      Rails.logger.error "LDAP Connection Error: #{e.message}"
      puts e.message
      raise(ExceptionHandler::AuthenticationServerIsDown, Message.contact_the_admin)
    rescue Exception => e
      Rails.logger.error "LDAP Error: #{e.message}"
      raise(ExceptionHandler::AuthenticationServerIsDown, Message.contact_the_admin)
    end
  end

  def get_user_role(query_result)
    if query_result.size === 1
      user_groups = query_result[0][:memberof][0].to_s

      if user_groups.include?("CN=#{DomainDefinition::USER_GROUP_INSTRUCTOR}")
        return User.roles[:instructor]
      end

      if user_groups.include?("CN=#{DomainDefinition::USER_GROUP_STUDENT}")
        return User.roles[:student]
      end
    end

    raise(ExceptionHandler::AuthenticationError, Message.not_authorized)
  end
end
