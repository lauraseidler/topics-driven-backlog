class Sprint < ApplicationRecord
  belongs_to :course
  has_many :stories
  has_and_belongs_to_many :topics

  validates_presence_of :name, :start_date, :end_date, :course_id

  validate :end_date_is_after_start_date

  private

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, 'cannot be before the start date')
    end
  end
end