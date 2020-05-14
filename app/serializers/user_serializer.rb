class UserSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :email, :role, :permissions, :downgrade

  def permissions
    {
      :courses => {
        :read => scope.can?(:read, Course),
        :create => scope.can?(:create, Course),
      }
    }
  end

  def downgrade
    scope.is_downgrade
  end
end

