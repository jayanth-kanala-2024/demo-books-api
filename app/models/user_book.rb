class UserBook < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, uniqueness: { scope: :book_id, message: 'This combination already exists.' }

  enum status: { want_to_read: 'want_to_read', reading: 'reading', read: 'read' }
end
