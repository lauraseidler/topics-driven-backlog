class Topic < ApplicationRecord
  belongs_to :course
  has_many :stories, dependent: :nullify
  has_and_belongs_to_many :sprints, dependent: :nullify

  validates_presence_of :title, :course_id
  validates_format_of :url, :with => URI::regexp(%w(http https))

end
