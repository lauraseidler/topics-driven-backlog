class AddBacklogToStory < ActiveRecord::Migration[5.1]
  def change
    add_reference :stories, :backlog, index: true
    add_foreign_key :stories, :backlogs
  end
end
