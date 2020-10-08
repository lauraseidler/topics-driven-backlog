namespace :db do
  desc "Reset story Ids"
  task reset_story_ids: :environment do
    Project.all.each.with_index(1) do |project, project_index|
        project.stories.order('created_at').all.each.with_index(1) do |story, story_index|
          story.update_column :identifier, 'S-'+story_index.to_s
        end
    end
  end
end
