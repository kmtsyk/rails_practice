class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.integer :price
      t.string :publisher
      t.date :published
      t.boolean :dl

      t.timestamps
    end
  end
end
