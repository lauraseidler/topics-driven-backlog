class ProjectSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :course_id, :permissions
  # only render user_ids if user can read project
  attribute :user_ids, if: :can_read_project?
  # render stories if user can read stories
  has_many :stories, if: :can_read_stories?

  def can_read_project?
    scope.can?(:read, Project, object)
  end

  def can_read_stories?
    scope.can?(:read, Story, object)
  end

  def permissions
    {
        :stories => {
            :read => scope.can?(:read, Story, object),
            :create => scope.can?(:create, Story, object),
        },
        :project => {
            :update => scope.can?(:update, object),
            :delete => scope.can?(:delete, object),
        }
    }
  end

end
