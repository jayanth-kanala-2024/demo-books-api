class UserBooksController < ApplicationController
  before_action :set_user_id

  # GET /users/:user_id/books
  def index
    user = User.find(@user_id)
    user_books = user.user_books.includes(:book)
    render json: UserBookSerializer.new(user_books, include: [:book]).serialized_json, status: :ok
  end

  # GET /users/:user_id/books/:book_id
  def show
    # user = User.find(@user_id)
    # user_books = user.user_books.includes(:book)
    # book_id = params[:book_id]
    # filtered_user_books = user_books.where(book_id: book_id)
    # render json: UserBookSerializer.new(filtered_user_books).serialized_json, status: :ok
    user_book = UserBook.find_by(user_id: params[:user_id], book_id: params[:book_id])
    render json: UserBookSerializer.new(user_book, include: [:book]).serialized_json, status: :ok
  end

  # POST /users/:user_id/books
  def create
    puts "create #{@user_id}"
    user_book = UserBook.new(user_book_params)
    user_book.user_id = @user_id
    pp user_book
    if user_book.save
      render json: UserBookSerializer.new(user_book).serialized_json, status: :created
    else
      render json: user_book.errors, status: :unprocessable_entity
    end
  end

  # PUT PATCH /users/:user_id/books/:book_id
  def update
    puts "update user_id: #{@user_id}, book_id: #{user_book_params[:book_id]}"
    user_book = UserBook.find_by(user_id: @user_id, book_id: user_book_params[:book_id])
    if user_book.update(user_book_params)
      render json: UserBookSerializer.new(user_book).serialized_json, status: :ok
    else
      render json: user_book.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user_id
    @user_id = request.env['user_id']
  end

  # Only allow a list of trusted parameters through.
  def user_book_params
    params.require(:data).require(:attributes).permit(:book_id, :user_id, :status)
  end
end
