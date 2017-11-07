class Story < ApplicationRecord
  has_many :tasks, dependent: :destroy
  acts_as_list

  validates_presence_of :title
end
