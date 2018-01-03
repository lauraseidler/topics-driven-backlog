class AddTopicReferenzToStory < ActiveRecord::Migration[5.1]
  def change
    add_reference :stories, :topic, foreign_key: true
  end
end
