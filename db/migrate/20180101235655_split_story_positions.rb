class SplitStoryPositions < ActiveRecord::Migration[5.1]
  def change
    create_table :sprint_positions do |t|
      t.integer :position
      t.references :sprint, foreign_key: true
    end

    create_table :project_positions do |t|
      t.integer :position
      t.references :project, foreign_key: true
    end

    remove_column :stories, :position
    add_reference :stories, :sprint_position, foreign_key: true
    add_reference :stories, :project_position, foreign_key: true
  end
end
