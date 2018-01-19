class CreateSprintsTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :sprints_topics do |t|
      t.references :sprint, foreign_key: true
      t.references :topic, foreign_key: true
    end
  end
end
