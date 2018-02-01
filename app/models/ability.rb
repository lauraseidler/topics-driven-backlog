class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    @user_id = user.id

    return unless user.present?

    # TODO Delete task
    can :manage, Task


    # COURSES
    can :read, Course

    if has_instructor_role
      can :create, Course
    end

    can [:update, :delete], Course do |course|
      is_instructor(course)
    end


    # TOPICS & SPRINTS
    can :read, Topic do |topic|
      is_instructor(topic.course) || is_member_in_course(topic.course)
    end

    can :read, Sprint do |sprint|
      is_instructor(sprint.course) || is_member_in_course(sprint.course)
    end

    can [:read_topics, :read_sprints], Course do |course|
      is_instructor(course) || is_member_in_course(course)
    end

    can [:create_topics, :create_sprints], Course do |course|
      is_instructor(course)
    end

    can [:update, :delete], Topic do |topic|
      is_instructor(topic.course)
    end

    can [:update, :delete], Sprint do |sprint|
      is_instructor(sprint.course)
    end


    # PROJECTS
    can :read_fully, Project do |project|
      is_instructor(project.course) || is_member(project)
    end

    can :create_projects, Course do |course|
      enrollment_allowed(course)
    end

    can :enroll, Project do |project|
      enrollment_allowed(project.course) && !is_member_in_course(project.course)
    end

    can [:update, :delete], Project do |project|
      is_instructor(project.course) ||
          ( is_member(project) && enrollment_allowed(project.course) )
    end


    # STORIES
    can :read, Story do |story|
      is_instructor(story.project.course)
    end

    can :read_stories, Project do |project|
      is_instructor(project.course) || is_member(project)
    end

    can :create_stories, Project do |project|
      is_member(project)
    end
    
    can :manage, Story do |story|
      is_member(story.project)
    end

  end

  private

  def has_instructor_role
    @user.role === User.roles[:instructor]
  end

  def is_instructor(course)
    course.user_ids.include?(@user_id)
  end

  def is_member(project)
    project.user_ids.include?(@user_id)
  end

  def is_member_in_course(course)
    member = false

    course.projects.each do |project|
      if is_member(project)
        member = true
        break
      end
    end

    member
  end

  def enrollment_allowed(course)
    course.allow_enrollment
  end
end
