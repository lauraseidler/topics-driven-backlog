class StorySerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :description, :position, :identifier, :status, :points, :sprint_id, :project_id
  # model association
  has_many :tasks
end
