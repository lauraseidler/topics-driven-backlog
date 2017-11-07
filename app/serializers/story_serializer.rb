class StorySerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :description, :created_at, :updated_at, :position
  # model association
  has_many :tasks
end
