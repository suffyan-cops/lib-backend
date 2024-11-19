class AddCascadeForeignKeyToUsersLibrary < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :users, :libraries, on_delete: :cascade
  end
end
