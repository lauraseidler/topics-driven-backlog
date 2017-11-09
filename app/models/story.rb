class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  acts_as_list

  def self.statuses
    {:open => 0, :progressing => 1, :closed => 2}
  end

  validates_presence_of :title
end
