module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  def raise_exception_on_validation_error(errors)
    errors = errors - ['', nil]

    if !errors.empty?
      raise ActionController::BadRequest.new('Validation failed: ' + errors.join(", "))
    end
  end

  included do
    rescue_from ActionController::BadRequest, with: :bad_request
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :record_invalid
    rescue_from ExceptionHandler::InvalidToken, with: :record_invalid
  end

  private

  # JSON response with message; Status code 400 - bad request
  def bad_request(e)
    json_response({ message: e.message }, :bad_request)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end

  # JSON response with message; Status code 404 - record not found
  def record_not_found(e)
    json_response({ message: e.message }, :not_found)
  end

  # JSON response with message; Status code 422 - unprocessable entity
  def record_invalid(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

end