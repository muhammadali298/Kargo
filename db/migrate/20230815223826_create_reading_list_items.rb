class CreateReadingListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :reading_list_items do |t|
      t.references :book, null: false, foreign_key: true
      t.references :reading_list, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
