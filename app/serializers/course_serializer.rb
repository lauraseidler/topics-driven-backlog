class CourseSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :hyperlink, :created_at, :updated_at, :semester_type, :semester_year
  # model association
  has_many :sprints
end
