class RemoveForeignKeyFromUsersLibrary < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :users, :libraries
  end
end
