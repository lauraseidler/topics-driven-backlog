module SprintsHelper

  def create_sprint_collection(duration, start_date, end_date)
    sprints = []
    days = (start_date...end_date).count
    number_of_sprints = days/duration

    number_of_sprints.times do |i|
      end_date = start_date + duration.days
      sprint = @course.sprints.create!(
          { :name => "#{i+1}. Sprint",
            :start_date => start_date,
            :end_date => end_date
          }
      )
      sprints.append(sprint)
      start_date = end_date
    end

    sprints
  end

end
