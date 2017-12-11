module SprintsHelper

  def validate_sprint_date_parameter
    errors = []

    errors.append(
        end_date_is_after_start_date(params[:start_date] || '', params[:end_date] || '')
    )

    raise_exception_on_validation_error(errors)
  end

  def validate_sprint_collision
    errors = []

    errors.append(
        sprint_does_not_collide(@sprint, params[:start_date], params[:end_date])
    )

    raise_exception_on_validation_error(errors)
  end

  private

  def end_date_is_after_start_date(start_date, end_date)
    if end_date.empty? || start_date.empty?
      return 'Start date and end date cannot be empty'
    end

    if end_date < start_date
      'End date cannot be before the start date'
    end
  end

  def sprint_does_not_collide(sprint, start_date, end_date)
    course = sprint.course
    collision = Sprint.where(
        '(end_date > ? AND start_date < ?) AND course_id = ?',
        start_date,
        end_date,
        course.id
    )

    if !collision.empty?
      'Sprint dates collide with other sprints.'
    end
  end

  def raise_exception_on_validation_error(errors)
    errors = errors - ['', nil]

    if !errors.empty?
      raise ActionController::BadRequest.new('Validation failed: ' + errors.join(", "))
    end
  end
end
