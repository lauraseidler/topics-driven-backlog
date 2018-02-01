class Instruction < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :initial_instructor, inclusion: { in: [true, false] }
end
