class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :isbn, null: false
      t.string :title, null: false
      t.string :author, null: false

      t.timestamps
    end
    add_index :books, :isbn, unique: true
    add_index :books, :title
    add_index :books, :author
  end
end
