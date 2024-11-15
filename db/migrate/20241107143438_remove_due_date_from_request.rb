class RemoveDueDateFromRequest < ActiveRecord::Migration[7.1]
  def change
    remove_column :requests, :due_date, :date
  end
end
