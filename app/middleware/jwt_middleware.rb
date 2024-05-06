# lib/jwt_middleware.rb
class JwtMiddleware
  EXCLUDED_PATHS = [
    '/auth/login',
    '/auth/signup',
    # '/auth/logout',
    '/auth/email',
    '/auth/verify',
    '/i18n'
  ].freeze # Add paths to exclude here

  JWT_ALGO = 'HS256'

  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) if excluded_path?(env['PATH_INFO'])
    token = extract_token_from_headers(env['HTTP_AUTHORIZATION'])
    return unauthorized_response('Missing token') unless token.present?

    begin
      payload = decode_token(token)
      is_exist = JwtMiddleware.token_exists?(payload.first['user_id'], token)
      puts "PAYLOAD MIDDLEWARE #{payload}, token in redis? #{is_exist}"
      return unauthorized_response('Invalid token') unless is_exist
      env['jwt.token'] = token
      env['jwt.payload'] = payload
      env['user_id'] = payload.first['user_id']
      env['role'] = payload.first['role']
    rescue JWT::DecodeError => e
      pp e
      return unauthorized_response(e.message)
    end

    @app.call(env)
  end

  def self.create_token(user)
    secret = Rails.application.credentials.dig(:jwt, :hmac_secret_key)
    payload = { user_id: user.id, role: user.role, exp: get_expiry_time }
    JWT.encode(payload, secret, JWT_ALGO)
  end

  def self.store_token_to_redis(user_id, token)
    redis_client = RedisClient.redis
    key = "user:#{user_id}:tokens"
    redis_client.sadd(key, token)

    # Set expiration time for the token at
    redis_client.expireat(key, get_expiry_time)
  end

  def self.delete_token_from_redis(user_id, token)
    redis_client = RedisClient.redis
    key = "user:#{user_id}:tokens"
    redis_client.del(key, token)
  end

  def self.token_exists?(user_id, token)
    redis_client = RedisClient.redis
    key = "user:#{user_id}:tokens"
    redis_client.sismember(key, token)
  end


  private

  def extract_token_from_headers(auth_header)
    token = auth_header.split(' ').last if auth_header.present? && auth_header.include?('Bearer')
  end

  def decode_token(token)
    secret = Rails.application.credentials.dig(:jwt, :hmac_secret_key)
    JWT.decode(token, secret, true, { algorithm: JWT_ALGO })
  end

  def unauthorized_response(message)
    [401, { 'Content-Type' => 'application/json' }, [{ error: true, message: message, isAuthenticated: false }.to_json]]
  end

  def excluded_path?(path)
    EXCLUDED_PATHS.any? { |excluded_path| path.start_with?(excluded_path) }
  end

  def self.get_expiry_time()
    # 1 day = 24 * 60 * 60 = 86,400 seconds
    # Calculate expiration time (60 minutes from now)
     Time.now.to_i + (24 * 60 * 60)
  end

  # def excluded_method?(method)
  #   EXCLUDED_METHODS.include?(method)
  # end
end
