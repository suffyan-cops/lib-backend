class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 50
      t.string :email, null: false, limit: 100
      t.string :password_digest, null: false
      t.references :libraries, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
    add_index :users, [:email], unique: true
  end
end
