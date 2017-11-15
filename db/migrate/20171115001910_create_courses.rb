class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :hyperlink
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
