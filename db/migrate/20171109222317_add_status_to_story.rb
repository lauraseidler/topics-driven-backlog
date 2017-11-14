class AddStatusToStory < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :status, :integer, default: Story.statuses[:open]
    Story.all.each.with_index(1) do |story|
      story.update_column :status, Story.statuses[:open]
    end
  end
end
