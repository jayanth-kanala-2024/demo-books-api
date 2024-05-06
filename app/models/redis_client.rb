class RedisClient
  def self.redis
    @redis ||= Redis.new
  end

  def self.reconnect
    @redis&.quit
    @redis = Redis.new
  end
end
