class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  # protect_from_forgery with: :exception
end
