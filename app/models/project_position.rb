class ProjectPosition < ApplicationRecord
  acts_as_list scope: [:project_id]

  validates_presence_of :project_id, :story_id, :position
end
