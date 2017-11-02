class CreateBacklogs < ActiveRecord::Migration[5.1]
  def change
    create_table :backlogs do |t|

      t.timestamps
    end
  end
end
