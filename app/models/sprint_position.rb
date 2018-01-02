class SprintPosition < ApplicationRecord
  acts_as_list scope: [:sprint_id]

  validates_presence_of :sprint_id, :position
end
