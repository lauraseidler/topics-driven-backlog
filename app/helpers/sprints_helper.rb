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
        end_date_is_after_start_date(params[:start_date], params[:end_date])
    )

    errors = errors - ['', nil]

    if !errors.empty?
      raise ActionController::BadRequest.new('Validation failed: ' + errors.join(", "))
    end
  end

  def end_date_is_after_start_date(start_date, end_date)
    if end_date.empty? || start_date.empty?
      return 'Start date and end date cannot be empty'
    end

    if end_date < start_date
      'End date cannot be before the start date'
    end
  end

  def duration_cannot_be_empty(duration)
    if duration == 0 || duration.blank?
      'Duration must be at least 1'
    end
  end

end
