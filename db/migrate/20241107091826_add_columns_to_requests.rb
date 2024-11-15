class AddColumnsToRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :requests, :book_id, :integer
    add_column :requests, :user_id, :integer
    add_column :requests, :status, :integer
    add_column :requests, :due_date, :date

    add_column :requests, :returned_date, :date
  end
end
