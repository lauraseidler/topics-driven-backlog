# Source: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-two

module ControllerSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  # return valid headers
  def valid_headers
    {

        "Authorization" => token_generator(create(:user).id),
        "Content-Type" => "application/json"
    }
  end

  # return invalid headers
  def invalid_headers
    {
        "Authorization" => nil,
        "Content-Type" => "application/json"
    }
  end
end
