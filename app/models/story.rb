class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  before_validation :set_identifier
  acts_as_list

  validates_presence_of :title, :identifier

  private
  def set_identifier
    self.identifier = 'S-'+(Story.last.id + 1).to_s
  end
end
