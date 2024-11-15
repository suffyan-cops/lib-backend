class RenameLibrariesIdToLibraryIdInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :libraries_id, :library_id
  end
end
