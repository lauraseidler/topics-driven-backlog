class AddMembership < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
    end
  end
end
