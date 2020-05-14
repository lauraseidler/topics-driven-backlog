class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  # POST /get-token
  def authenticate
    Rails.logger.info "User Login attempt with email address: #{auth_params[:email]}"
    json_response(AuthenticateUser.new(auth_params[:email],auth_params[:password]).call)
  end

  # POST /become-student
  def as_student
    json_response(DowngradeUser.new(current_user, true).call)
  end

  # POST /become-instructor
  def as_instructor
    json_response(DowngradeUser.new(current_user, false).call)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
