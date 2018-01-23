class AddRoleColumnOnUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :integer, default: User.roles[:student]
    User.all.each.with_index(1) do |user|
      user.update_column :role, User.roles[:student]
    end
  end
end
