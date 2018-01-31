class CourseSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :short_title, :hyperlink, :semester_type, :semester_year, :allow_enrollment, :permissions
  has_many :sprints
  has_many :topics
  has_many :projects

  def projects
    object.projects.map do |project|
      if scope.can?(:read, project, object)
        ProjectSerializer.new(project, scope: scope, root: true, event: object)
      else
        ProjectShortSerializer.new(project, scope: scope, root: true, event: object)
      end
    end
  end

  def topics
    object.topics.select do |topic|
      if scope.can?(:read, topic, object)
        TopicSerializer.new(topic, scope: scope, root: true, event: object)
      end
    end
  end

  def sprints
    object.sprints.select do |sprint|
      if scope.can?(:read, sprint, object)
        SprintSerializer.new(sprint, scope: scope, root: true, event: object)
      end
    end
  end

  def permissions
    [
        :sprints => [
          :read => scope.can?(:read, Sprint, object),
          :create => scope.can?(:create, Sprint, object),
        ],
        :topics => [
            :read => scope.can?(:read, Topic, object),
            :create => scope.can?(:create, Topic, object),
        ],
        :projects => [
            :read => scope.can?(:read, Project, object),
            :create => scope.can?(:create, Project, object),
        ],
        :course => [
            :update => scope.can?(:update, object),
            :delete => scope.can?(:delete, object),
        ]
    ]
  end
end
