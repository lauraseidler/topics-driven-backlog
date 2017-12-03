class StoryPositionDependsOnSprint < ActiveRecord::Migration[5.1]
  def change
    Story.each do |story|
      story.position = 0
    end
    Story.order(:created_at).reverse.each do |story|
      story.move_to_bottom
    end
  end
end
