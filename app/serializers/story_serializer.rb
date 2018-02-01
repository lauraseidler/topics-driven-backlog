class StorySerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :description, :sprint_position, :project_position, :identifier, :status, :points, :sprint_id, :topic_id, :project_id, :permissions

  def sprint_position
    sprint_position = SprintPosition.find_by(story_id: object.id)
    if sprint_position.present?
      sprint_position.position
    end
  end

  def project_position
    project_position = ProjectPosition.find_by(story_id: object.id)
    if project_position.present?
      project_position.position
    end
  end

  def permissions
    {
        :story => {
            :update => scope.can?(:update, object),
            :delete => scope.can?(:delete, object),
        }
    }
  end
end
