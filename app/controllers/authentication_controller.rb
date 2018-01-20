class AuthenticationController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  skip_before_action :authorize_request, only: :authenticate

  # POST /get-token
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
    auth_token =
        AuthenticateUser.new(username, password).call
    json_response(auth_token: auth_token)
    end
  end
end
