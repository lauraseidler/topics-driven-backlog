class BacklogSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :created_at, :updated_at
  # model association
  has_many :stories
end
