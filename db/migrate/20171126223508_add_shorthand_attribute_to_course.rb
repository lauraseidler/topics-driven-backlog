class AddShorthandAttributeToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :alias, :string, default: nil
  end
end
