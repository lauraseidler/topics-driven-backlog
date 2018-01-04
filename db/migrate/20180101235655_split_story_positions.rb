class SplitStoryPositions < ActiveRecord::Migration[5.1]
  def change
    create_table :sprint_positions do |t|
      t.integer :position
      t.references :sprint, foreign_key: {on_delete: :cascade}
      t.references :story, foreign_key: {on_delete: :cascade}
    end

    create_table :project_positions do |t|
      t.integer :position
      t.references :project, foreign_key: {on_delete: :cascade}
      t.references :story, foreign_key: {on_delete: :cascade}
    end

    remove_column :stories, :position
  end
end
