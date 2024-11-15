class AddCreatedByToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :created_by, :integer
  end
end
