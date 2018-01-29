class SprintSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :name, :start_date, :end_date, :course_id, :topic_ids, :permissions

  def permissions
    [
        :read => scope.can?(:read, object),
        :create => scope.can?(:create, object, object.course),
        :update => scope.can?(:update, object),
        :delete => scope.can?(:delete, object),
        :manage_collection => scope.can?(:collection, object, object.course)
    ]
  end
end
