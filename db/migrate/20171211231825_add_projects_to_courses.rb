class AddProjectsToCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.references :course, foreign_key: true

      t.timestamps
    end

    add_reference :stories, :project, foreign_key: true

  end
end
