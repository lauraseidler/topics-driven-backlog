class Course < ApplicationRecord
  has_many :sprints, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :projects, dependent: :destroy


  def self.semester_types
    {:summer => 'S', :winter => 'W'}
  end

  validates_presence_of :title
  validates :semester_year, length: { is: 4 , message: 'must be in format YYYY'}
  validates :semester_type, inclusion: { in: %w(S W), message: 'must be `S` or `W`' }

end
