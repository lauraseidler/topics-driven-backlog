class StorySerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :position, :description, :created_at, :updated_at
  # model association
  has_many :tasks
end
