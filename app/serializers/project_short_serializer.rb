class ProjectShortSerializer < ActiveModel::Serializer
  attributes :id, :title, :permissions

  def permissions
    [
        :stories => [
            :read => scope.can?(:read, Story, object),
            :create => scope.can?(:create, Story, object),
        ],
        :project => [
            :update => scope.can?(:update, object),
            :delete => scope.can?(:delete, object),
        ]
    ]
  end
end