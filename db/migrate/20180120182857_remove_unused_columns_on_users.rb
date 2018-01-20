class RemoveUnusedColumnsOnUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :password_digest
    remove_column :users, :name
  end
end
