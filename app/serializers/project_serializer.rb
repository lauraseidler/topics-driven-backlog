class ProjectSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :course_id, :user_ids, :permissions
  # model association
  has_many :stories

  def stories
    object.stories.select do |story|
      if scope.can?(:read, story, object)
        StorySerializer.new(story, scope: scope, root: true, event: object)
      end
    end
  end

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
