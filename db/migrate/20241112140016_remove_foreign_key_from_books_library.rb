class RemoveForeignKeyFromBooksLibrary < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :books, :libraries
  end
end
