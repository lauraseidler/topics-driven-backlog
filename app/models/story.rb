class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy

  def self.statuses
    {:open => 0, :progressing => 1, :closed => 2, :canceled => 3}
  end

  acts_as_list

  after_save :set_identifier
  before_validation :set_status

  validates_presence_of :title, :status
  validate :can_be_edited

  private

  def set_identifier
    if self.identifier.blank?
      self.identifier = 'S-'+self.id.to_s
    end
  end

  def set_status
    if self.status.blank?
      self.status = Story.statuses[:open]
    end
  end

  def can_be_edited
    if sprint_id_was.present?
      old_sprint = Sprint.find_by!(id: sprint_id_was)
      is_sprint_finished(old_sprint)
    end

    if sprint_id.present?
      sprint = Sprint.find_by!(id: sprint_id)
      is_sprint_finished(sprint)
    end
  end

  def is_sprint_finished(sprint)
    if sprint.end_date < Date.today
      errors.add(:sprint_id, 'was finished and cannot be changed')
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

end
