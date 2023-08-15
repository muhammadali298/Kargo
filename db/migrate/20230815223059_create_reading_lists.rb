class CreateReadingLists < ActiveRecord::Migration[7.0]
  def change
    create_table :reading_lists do |t|
      t.string :title, null: false

      t.timestamps
    end
    add_index :reading_lists, :title
  end
end
