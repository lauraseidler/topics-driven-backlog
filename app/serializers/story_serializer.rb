class StorySerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :description, :position, :identifier, :status, :points, :sprint_id, :topic_id, :project_id
end
