class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :backlog
  acts_as_list scope: :backlog

  validates_presence_of :title
end
