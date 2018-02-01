class CourseSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :short_title, :hyperlink, :semester_type, :semester_year, :allow_enrollment, :permissions
  attribute :instructors, if: :can_update_course?

  has_many :sprints, if: :can_read_sprints?
  has_many :topics, if: :can_read_topics?
  has_many :projects

  def instructors
    object.instructions
  end

  def can_update_course?
    scope.can?(:update, object)
  end

  def can_read_sprints?
    scope.can?(:read_sprints, object)
  end

  def can_read_topics?
    scope.can?(:read_topics, object)
  end

  def permissions
    {
        :sprints => {
            :read => scope.can?(:read_sprints, object),
            :create => scope.can?(:create_sprints, object),
        },
        :topics => {
            :read => scope.can?(:read_topics, object),
            :create => scope.can?(:create_topics, object),
        },
        :projects => {
            :create => scope.can?(:create_projects, object),
        },
        :course => {
            :update => scope.can?(:update, object),
            :delete => scope.can?(:delete, object),
            :remove_instructor => scope.can?(:remove_instructor, object),
        }
    }
  end
end
