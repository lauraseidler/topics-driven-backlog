class Topic < ApplicationRecord
  belongs_to :course
  has_many :stories, dependent: :nullify

  validates_presence_of :title, :course_id
  validates_format_of :url, :with => URI::regexp(%w(http https))

end
