class AddCascadeForeignKeyToMembersLibrary < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :members, :libraries, on_delete: :cascade
  end
end
