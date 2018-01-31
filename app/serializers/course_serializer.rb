class CourseSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :short_title, :hyperlink, :semester_type, :semester_year, :allow_enrollment, :permissions
  has_many :sprints
  has_many :topics
  has_many :projects

  def permissions
    [
        :sprints => [
          :read => scope.can?(:read, Sprint, object),
          :create => scope.can?(:read, Sprint, object),
        ],
        :topics => [
            :read => scope.can?(:read, Topic, object),
            :create => scope.can?(:read, Topic, object),
        ],
        :projects => [
            :read => scope.can?(:read, Project, object),
            :create => scope.can?(:read, Project, object),
        ],
        :course => [
            :update => scope.can?(:update, object),
            :delete => scope.can?(:delete, object),
        ]
    ]
  end
end
