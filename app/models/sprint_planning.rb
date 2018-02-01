class SprintPlanning < ApplicationRecord
  belongs_to :project
  belongs_to :sprint

  validates :planned, inclusion: { in: [true, false] }
end
