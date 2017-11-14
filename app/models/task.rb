class Task < ApplicationRecord
  belongs_to :story

  validates_presence_of :title, :story_id
end
