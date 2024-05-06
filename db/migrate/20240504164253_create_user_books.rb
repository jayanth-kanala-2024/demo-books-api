class CreateUserBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_books do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.string :status

      t.boolean :deleted, default: false
      t.timestamp :deleted_at

      t.timestamps
    end
    # Add a unique index to ensure each combination of user_id and book_id is unique
    add_index :user_books, [:user_id, :book_id], unique: true
  end
end
