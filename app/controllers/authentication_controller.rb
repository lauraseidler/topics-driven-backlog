class AuthenticationController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  skip_before_action :authorize_request, only: :authenticate

  # POST /get-token
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
    json_response(AuthenticateUser.new(username, password).call)
    end
  end
end
