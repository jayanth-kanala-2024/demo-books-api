class User < ApplicationRecord
    has_secure_password

    has_many :user_books
    has_many :books, through: :user_books

    # terms validation and dont save in db
    attr_accessor :terms
   
    # alias form attribute to model column
    alias_attribute :confirm_password, :password_confirmation

    validates :name, :email, :password, :password_confirmation, presence: true
    validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
    # minimum 8 characters with atleast 1 lower, 1 upper, 1 number, 1 special char
    validates :password, length: {minimum:8}, format: { with: /(?=.*\d)(?=.*[a-z]){1,}(?=.*[A-Z]){1,}(?=.*[!@#$%^&*]{1,}).{8,}/}
    validates :name, length: {minimum:3}

    # user roles enums
    enum role: { regular: "regular", admin: "admin" }

end

