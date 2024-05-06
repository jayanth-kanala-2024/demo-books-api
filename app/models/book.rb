require 'elasticsearch/model'

class Book < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :reviews, dependent: :destroy
  has_many :user_books
  has_many :users, through: :user_books

  after_commit :index_document, on: %i[create update]
  after_commit :delete_document, on: :destroy

  attr_accessor :file

  validates :title, :description, :author, :isbn10, :isbn13, presence: true
  validates :isbn13, presence: true, uniqueness: true
  validates :isbn10, uniqueness: true, allow_nil: true
  attribute :price, :float, default: 0

  # Define methods for Elasticsearch search queries
  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            type: 'phrase_prefix'
          }
        }
      }
    )
  end

  private

  def index_document
    puts __elasticsearch__.index_document
  end

  def delete_document
    __elasticsearch__.delete_document
  end
end
