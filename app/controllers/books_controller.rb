class BooksController < ApplicationController
  before_action -> { authorize_user('admin') }, except: [:index, :show]
  before_action :set_book, only: %i[show update destroy]

  # GET /books
  def index
    # based on role
    if User.roles[:admin] == request.env['role']
      @books = Book.for_admin.all
    else
      @books = Book.all
    end
    render json: BookSerializer.new(@books).serialized_json, status: :ok
  end

  # GET /books/1
  def show
    render json: BookSerializer.new(@book, include: [:reviews]).serialized_json, status: :ok
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    # @book.coverImage = save_file(book_params) if book_params[:file]
    @book.coverImage = save_file(book_params[:title], book_params[:file]) if book_params[:file]

    if @book.save
      render json: BookSerializer.new(@book), status: :created
    else
      render json: ErrorSerializer.new(@book.errors).serialized_json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  def update
    params[:data][:attributes][:coverImage] = save_file(book_params[:title], book_params[:file]) if book_params[:file]
    if @book.update(book_params)
      render json: BookSerializer.new(@book).serialized_json, status: :ok
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    if @book.deleted
      puts "restore"
      @book.deleted = false
      @book.restore
    else
      puts "soft del"
      @book.soft_delete
    end
    head :no_content
  end

  private

  def save_file(filename, base64_file)
    return unless base64_file.present?

    extension, base64_value = extract_extension_base64_value(base64_file)

    decoded_data = Base64.decode64(base64_value)

    #replace special and spaces with _
    filename = filename.gsub(/[^0-9a-z]/i, '_')

    filename = "#{filename}#{extension}"

    # save in public books
    File.open(Rails.root.join('public', 'books', filename), 'wb') do |file|
      file.write(decoded_data)
    end

    filename
  rescue StandardError => e
    { error: e.message }
  end

  def extract_extension_base64_value(file)
    # Content type usually appears at the beginning of the base64 encoded data
    content_type, base64_value = file.split(/[:;]/)[1..2]
    base64_value = base64_value.split(',')[1]

    content_type ||= 'application/octet-stream' # Default to binary data if content type is not found

    extension = Rack::Mime::MIME_TYPES.invert[content_type]

    [extension, base64_value]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    if User.roles[:admin] == request.env['role']
      @book = Book.for_admin.find(params[:id])
    else
      @book = Book.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params
      .require(:data)
      .require(:attributes)
      .permit(
        :title,
        :description,
        :author,
        :contributor,
        :publisher,
        :price,
        :isbn10,
        :isbn13,
        :coverImage,
        :file
      )
  end
end
