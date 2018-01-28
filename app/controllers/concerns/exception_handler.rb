module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class AuthenticationServerIsDown < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end

  included do
    rescue_from ActionController::BadRequest, with: :bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::AuthenticationServerIsDown, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :invalid_token
    rescue_from ExceptionHandler::ExpiredSignature, with: :invalid_token
    rescue_from CanCan::AccessDenied, with: :unauthorized_request
  end

  private

  # JSON response with message; Status code 400 - bad request
  def bad_request(e)
    json_response({ message: e.message }, :bad_request)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({ message: Message.not_authorized }, :unauthorized)
  end

  # JSON response with message; Status code 404 - record not found
  def record_not_found(e)
    json_response({ message: e.message }, :not_found)
  end

  # JSON response with message; Status code 422 - unprocessable entity
  def record_invalid(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 498 - Invalid Token
  def invalid_token(e)
    json_response({ message: e.message }, :invalid_token)
  end

end
