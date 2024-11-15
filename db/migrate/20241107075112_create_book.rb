class CreateBook < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.string :quantity
      t.integer :publication_year

      t.references :library, foreign_key: true

      t.timestamps
    end
  end
end
