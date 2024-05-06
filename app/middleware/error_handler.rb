# app/middleware/error_handler.rb
class ErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue StandardError => e
    Rails.logger.error(e.inspect)
    [500, { 'Content-Type' => 'application/json' }, [{ error: 'Internal Server Error' }.to_json]]
  end
end
