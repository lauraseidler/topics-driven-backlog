class CreateInstructions < ActiveRecord::Migration[5.1]
  def change
    create_table :instructions do |t|
      t.boolean :initial_instructor
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true
      t.index([:user_id, :course_id], unique: true)
    end
  end
end
