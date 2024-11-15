class AddCascadeForeignKeyToBooksLibrary < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :books, :libraries, on_delete: :cascade
  end
end
