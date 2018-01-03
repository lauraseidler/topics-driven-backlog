class TopicSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :url
end
