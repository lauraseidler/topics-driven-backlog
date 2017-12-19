class ProjectSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :course_id
  # model association
  has_many :stories
end
