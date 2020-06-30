namespace :db do
  desc "Rest story Ids"
  task reset_story_ids: :environment do
    Story.all.each.with_index(1) do |story, id|
      story.update_column :identifier, 'S-'+id.to_s
    end
  end
end
