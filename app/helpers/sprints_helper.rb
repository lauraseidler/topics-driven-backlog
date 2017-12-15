module SprintsHelper
  def create_sprint_collection(duration, start_date, end_date)
    sprints = []
    days = (start_date...end_date).count + 1
    number_of_sprints = days/duration

    number_of_sprints.times do |i|
      end_date = start_date + duration.days - 1.days
      sprint = @course.sprints.create!(
          { :name => "#{i+1}. Sprint",
            :start_date => start_date,
            :end_date => end_date
          }
      )
      sprints.append(sprint)
      start_date = end_date + 1.days
    end

    sprints
  end

  def validate_sprint_collection_params
    errors = []

    errors.append(
        duration_cannot_be_empty(params[:duration].to_i)
    )
    errors.append(
        valid_date_range(params[:start_date], params[:end_date])
    )

    raise_exception_on_validation_error(errors)
  end



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

  def validate_sprint_collision
    errors = []

    errors.append(
        sprint_does_not_collide(@sprint, params[:start_date], params[:end_date])
    )

    raise_exception_on_validation_error(errors)
  end

  private

  def duration_cannot_be_empty(duration)
    if duration == 0 || duration.blank?
      'Duration must be at least 1'
    end
  end

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
