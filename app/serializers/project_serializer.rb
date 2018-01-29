class ProjectSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :course_id, :user_ids, :permissions
  # model association
  has_many :stories

  def permissions
    [
        :read => scope.can?(:read, object),
        :create => scope.can?(:create, object, object.course),
        :update => scope.can?(:update, object),
        :delete => scope.can?(:delete, object),
        :enrollment => scope.can?(:enrollment, object, object.course)
    ]
  end

  def user_ids
    if scope.can?(:read, object)
      return object.user_ids
    end
    []
  end
end
