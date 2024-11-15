class AddCreatedByToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :created_by, :integer
  end
end
