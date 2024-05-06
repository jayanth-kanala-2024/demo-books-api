class SearchController < ApplicationController
  def index
    books = Book.search(params[:q])
    render json: BookSerializer.new(books.records).serialized_json
  end

  private

  def ping
    if Elasticsearch::Model.client.ping
      render json: { message: 'Elasticsearch server is reachable' }
    else
      render json: { error: 'Failed to connect to Elasticsearch server' }, status: :internal_server_error
    end
  end
end
