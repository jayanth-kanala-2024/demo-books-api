class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  attributes :reviewer_name, :rating, :comment 
  
  belongs_to :book
end
