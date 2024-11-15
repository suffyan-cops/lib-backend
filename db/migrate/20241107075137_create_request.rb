class CreateRequest < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.integer :status, default: 0
      t.date :due_date
      t.date :returned_date

      t.timestamps
    end
  end
end
