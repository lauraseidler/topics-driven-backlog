class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  after_save :set_identifier
  acts_as_list

  def self.statuses
    {:open => 0, :progressing => 1, :closed => 2}
  end

  validates_presence_of :title

  private
  def set_identifier
    if self.identifier.blank?
      self.identifier = 'S-'+self.id.to_s
    end
  end
end
