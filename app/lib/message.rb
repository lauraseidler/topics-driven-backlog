# https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-two

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

end
