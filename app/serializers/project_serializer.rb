class ProjectSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :course_id, :user_ids
  # model association
  has_many :stories
end
