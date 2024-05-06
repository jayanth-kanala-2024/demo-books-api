class UserBookSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :user
  belongs_to :book
  attributes :status
end
