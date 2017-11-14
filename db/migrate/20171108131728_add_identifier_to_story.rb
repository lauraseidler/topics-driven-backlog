class AddIdentifierToStory < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :identifier, :string
    Story.all.each.with_index(1) do |story, id|
      story.update_column :identifier, 'S-'+id.to_s
    end
  end
end
