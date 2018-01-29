class CourseSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :short_title, :hyperlink, :semester_type, :semester_year, :allow_enrollment, :permissions
  # model association
  has_many :sprints
  has_many :topics
  has_many :projects

  def permissions
    [
        :read => scope.can?(:read, object),
        :create => scope.can?(:create, object),
        :update => scope.can?(:update, object),
        :delete => scope.can?(:delete, object),
    ]
  end
end
