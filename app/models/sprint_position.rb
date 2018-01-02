class SprintPosition < ApplicationRecord
  acts_as_list scope: [:sprint_id]

  validates_presence_of :sprint_id, :story_id, :position
end
