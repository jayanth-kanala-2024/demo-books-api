class ReviewsController < ApplicationController
  before_action :set_book, only: [:create]
  before_action :set_review, only: %i[show update destroy]

  # GET /books/:book_id/reviews
  def index
    reviews = @book.reviews
    render json: ReviewSerializer.new(reviews).serialized_json
  end

  # GET /books/:book_id/reviews/:id
  def show
    render json: ReviewSerializer.new(@review).serialized_json
  end

  # POST /books/:book_id/reviews
  def create
    review = @book.reviews.new(review_params)
    if review.save
      render json: ReviewSerializer.new(review).serialized_json
    else
      render json: { errors: review.errors }, status: :unprocessable_entity
    end
  end

  # PATCH /books/:book_id/reviews/:id
  def update
    if @review.update(review_params)
      render json: ReviewSerializer.new(@review).serialized_json
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /books/:book_id/reviews/:id
  def destroy
    @review.soft_delete
    head :no_content
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:data).require(:attributes).permit(:reviewer_name, :rating, :comment)
  end
end
