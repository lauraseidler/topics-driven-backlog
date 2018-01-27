class Project < ApplicationRecord
  belongs_to :course
  has_many :stories, dependent: :destroy
  has_and_belongs_to_many :users

  validates_presence_of :title, :course_id
  validates :title, uniqueness: { scope: :course_id }

  validate :enrollment_is_allowed

  private

  def enrollment_is_allowed
    if Course.find_by(id: course_id, allow_enrollment: true).nil?
      errors.add(:course, 'enrollment is closed, no changes on projects are permitted')
    end
  end
end
