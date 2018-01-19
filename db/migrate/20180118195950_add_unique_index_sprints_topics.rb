class AddUniqueIndexSprintsTopics < ActiveRecord::Migration[5.1]
  def change
    add_index :sprints_topics, [:sprint_id, :topic_id], unique: true
  end
end
