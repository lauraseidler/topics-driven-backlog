class CourseSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :short_title, :hyperlink, :semester_type, :semester_year, :allow_enrollment, :permissions

  has_many :sprints, if: :can_read_sprints?
  has_many :topics, if: :can_read_topics?
  has_many :projects

  def can_read_sprints?
    scope.can?(:read, Sprint, object)
  end

  def can_read_topics?
    scope.can?(:read, Topic, object)
  end

  def permissions
    {
        :sprints => {
            :read => scope.can?(:read, Sprint, object),
            :create => scope.can?(:create, Sprint, object),
        },
        :topics => {
            :read => scope.can?(:read, Topic, object),
            :create => scope.can?(:create, Topic, object),
        },
        :projects => {
            :read => scope.can?(:read, Project, object),
            :create => scope.can?(:create, Project, object),
        },
        :course => {
            :update => scope.can?(:update, object),
            :delete => scope.can?(:delete, object),
        }
    }
  end
end
