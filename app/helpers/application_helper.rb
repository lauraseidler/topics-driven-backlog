module ApplicationHelper

  def raise_exception_on_validation_error(errors)
    errors = errors - ['', nil]

    if !errors.empty?
      raise ActionController::BadRequest.new('Validation failed: ' + errors.join(", "))
    end
  end

  def validate_email_address(email)
    if !email.include?(DomainDefinition::ORGANISATION_DOMAIN)
      raise(ActionController::BadRequest, Message.not_domain_email_address(email))
    end
  end

end
