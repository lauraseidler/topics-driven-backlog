class AddPointsToStory < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :points, :integer, default: nil
    Story.all.each do |story|
      story.update_column :points, nil
    end
  end
end
