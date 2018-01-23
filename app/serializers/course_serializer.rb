class CourseSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :title, :short_title, :hyperlink, :semester_type, :semester_year, :allow_enrollment
  # model association
  has_many :sprints
  has_many :topics
  has_many :projects
end
