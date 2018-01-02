class StorySerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :description, :sprint_position, :project_position, :identifier, :status, :points, :sprint_id, :project_id

  def sprint_position
    sprint_position = SprintPosition.find_by(id: :sprint_position_id)
    if sprint_position.present?
      sprint_position.position
    end
  end

  def project_position
    project_position = ProjectPosition.find_by(id: :project_position_id)
    if project_position.present?
      project_position.position
    end
  end

end
