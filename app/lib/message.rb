class Message
  include DomainDefinition

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.not_authorized
    'Not authorized'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.contact_the_admin
    'Request failed. Please contact the administrator.'
  end

  def self.not_domain_email_address(email)
    "email needs to be like '*.#{DomainDefinition::ORGANISATION_DOMAIN}', but was: #{email}"
  end
end
