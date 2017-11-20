class SwapSemesterWithDatesOfStory < ActiveRecord::Migration[5.1]
  def change
    remove_column :courses, :start_date
    remove_column :courses, :end_date
    add_column :courses, :semester_type, :string
    add_column :courses, :semester_year, :integer, limit: 2
  end
end
