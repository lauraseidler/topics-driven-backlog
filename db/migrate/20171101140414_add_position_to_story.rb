class AddPositionToStory < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :position, :integer
    Story.order(:updated_at).each.with_index(1) do |story, index|
      story.update_column :position, index
    end
  end
end
