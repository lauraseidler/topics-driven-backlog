class Message

  def self.invalid_credentials
    'Invalid credentials'
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

  def self.not_htw_email(email)
    "email needs to be like '*.htw-berlin.de', but was: #{email}"
  end
end
