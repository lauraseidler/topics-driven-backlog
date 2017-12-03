class StoryPositionDependsOnSprint < ActiveRecord::Migration[5.1]
  def change
    Story.all.each do |story|
      story.position = 0
    end
    Story.all.order(:created_at).reverse.each do |story|
      story.move_to_bottom
    end
  end
end
