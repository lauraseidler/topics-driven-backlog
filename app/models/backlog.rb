class Backlog < ApplicationRecord
  has_many :stories, -> { order(position: :asc) }
end
