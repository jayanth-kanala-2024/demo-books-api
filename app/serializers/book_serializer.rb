class BookSerializer
  include FastJsonapi::ObjectSerializer
  has_many :reviews
  attributes :title, :description, :author, :contributor, :coverImage, :publisher, :price, :isbn10, :isbn13, :deleted, :created_at
end
