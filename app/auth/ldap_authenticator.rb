class LdapAuthenticator

  # Returns the user role of an user if this user was authenticated via ldap
  def initialize(username, password)
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
      end
    rescue Exception => e
      raise(ExceptionHandler::AuthenticationServerIsDown, e.message)
    end

    get_user_role(query_result)
  end

  private

  def get_user_role(query_result)
    if query_result.size === 1
      user_groups = query_result[0]['memberof'][0].split(',')

      if user_groups.include?("CN=#{DomainDefinition::USER_GROUP_INSTRUCTOR}")
        return User.roles[:instructor]
      end

      if user_groups.include?("CN=#{DomainDefinition::USER_GROUP_STUDENT}")
        return User.roles[:student]
      end
    end

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end