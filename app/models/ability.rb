class Ability
  include CanCan::Ability

  # Define abilities for the passed in user here. For example:
  #
  #   user ||= User.new # guest user (not logged in)
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

  def initialize(user)
    @user = user
    @user_id = user.id

    return unless user.present?
    can :manage, Task # Task needs to be deleted soon

    can :read, Course

    if has_instructor_role
      can :create, Course
    end

    can [:update, :delete], Course do |course|
      is_instructor(course)
    end

    can :read, Topic do |topic|
      if !is_instructor(sprint.course)
        topic.course.projects do |project|
          return true if is_member(project)
        end
      else
        return true
      end


      false
    end

    can :create, Topic do |t, course|
      is_instructor(course)
    end

    can [:update, :delete], Topic do |topic|
      is_instructor(topic.course)
    end

    can :read, Sprint do |sprint|
      if !is_instructor(sprint.course)
        sprint.course.projects do |project|
          return true if is_member(project)
        end
      else
        return true
      end

      false
    end

    can [:create, :update, :delete, :collection], Sprint do |s, course|
      if course.nil?
        course = s.course
      end
      is_instructor(course)
    end

    can :read, Project do |project|
      is_instructor(project.course) || is_member(project)
    end

    can :create, Project do |p, course|
      enrollment_allowed(course)
    end

    can :enrollment, Project do |project|
      enrollment_allowed(project.course)
    end

    can [:update, :delete], Project do |project|
      is_instructor(project.course) ||
          ( is_member(project) && enrollment_allowed(project.course) )
    end

    can :read, Story do |story|
      is_instructor(story.project.course)
    end

    can :create, Story do |s, project|
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

  def enrollment_allowed(course)
    course.allow_enrollment
  end
end
