class TopicSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :url, :course_id, :permissions

  def permissions
    [
        :read => scope.can?(:read, object),
        :create => scope.can?(:create, object, object.course),
        :update => scope.can?(:update, object),
        :delete => scope.can?(:delete, object),
    ]
  end
end
