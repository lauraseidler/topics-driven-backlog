class AddShorthandAttributeToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :short_title, :string, default: nil
  end
end
