module SprintsHelper

  def validate_sprint_date_parameter
    errors = []

    errors.append(
        valid_date_range(params[:start_date] || '', params[:end_date] || '')
    )
    errors.append(
        ends_in_the_future(params[:end_date] || '')
    )

    raise_exception_on_validation_error(errors)
  end

  private

  def valid_date_range(start_date, end_date)
    if end_date.empty? || start_date.empty?
      return 'Start date and end date cannot be empty'
    end

    if end_date < start_date
      'End date cannot be before the start date'
    end
  end

  def ends_in_the_future(end_date)
    if !end_date.empty?
      if Date.parse(end_date) < Date.today
        'End date cannot be in the past'
      end
    end
  end

  def raise_exception_on_validation_error(errors)
    errors = errors - ['', nil]

    if !errors.empty?
      raise ActionController::BadRequest.new('Validation failed: ' + errors.join(", "))
    end
  end
end
