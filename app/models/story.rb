class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  acts_as_list :column => :position

  validates_presence_of :title
end
