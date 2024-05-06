class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :reviewer_name, null: false
      t.integer :rating, null: false
      t.text :comment, null: false
      
      t.boolean :deleted, default: false
      t.timestamp :deleted_at

      t.belongs_to :book, null: false, foreign_key: true
      t.timestamps
    end
  end
end