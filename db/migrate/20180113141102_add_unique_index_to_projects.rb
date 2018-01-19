class AddUniqueIndexToProjects < ActiveRecord::Migration[5.1]
  def change
    add_index :projects, [:title, :course_id], unique: true
  end
end
