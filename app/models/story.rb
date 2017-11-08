class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  after_save :set_identifier
  acts_as_list

  validates_presence_of :title

  private
  def set_identifier
    if self.identifier.blank?
      self.identifier = 'S-'+self.id.to_s
    end
  end
end
