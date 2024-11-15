class CreateMember < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.date :membership_start_date
      t.integer :number_of_books_issued
      t.string :phone_number, null: false
      t.string :address, null: false
      t.references :library, foreign_key: true, null: true

      t.timestamps
    end
    add_index :members, [:email, :phone_number], unique: true
  end
end
