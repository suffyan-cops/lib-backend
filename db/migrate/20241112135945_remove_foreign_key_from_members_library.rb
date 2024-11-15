class RemoveForeignKeyFromMembersLibrary < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :members, :libraries
  end
end
