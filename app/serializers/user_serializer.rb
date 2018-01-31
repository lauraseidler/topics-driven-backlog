class UserSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :email, :role, :permissions
  has_many :courses

  def permissions
    [
        :courses => [
            :read => scope.can?(:read, Course),
            :create => scope.can?(:create, Course),
        ]
    ]
  end
end
