class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  after_save :set_identifier
  before_validation :set_status
  acts_as_list

  def self.statuses
    {:open => 0, :progressing => 1, :closed => 2, :canceled => 3}
  end

  validates_presence_of :title, :status

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
end
