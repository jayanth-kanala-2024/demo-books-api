class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :author, null: false
      t.string :contributor, null: false, default: ""
      t.string :publisher, null: false, default: ""
      t.decimal :price, precision: 8, scale: 2
      t.string :isbn10, null: false
      t.string :isbn13, null: false
      t.string :coverImage, null: false, default: ""

      t.boolean :deleted, default: false
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
