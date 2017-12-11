class Project < ApplicationRecord
  belongs_to :course
  has_many :stories

  validates_presence_of :title, :course_id
end
