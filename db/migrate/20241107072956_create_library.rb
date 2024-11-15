class CreateLibrary < ActiveRecord::Migration[7.1]
  def change
    create_table :libraries do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :email
      t.string :website
      t.timestamps
    end
  end
end
