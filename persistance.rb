require 'redis'
require 'json'

class Persistance
  def initialize
    @redis = Redis.new
  end

  def get(key)
    res = @redis.get(key.to_s)
    JSON.parse res rescue res
  end
  alias_method :[], :get

  def set(key, value)
    val = value.to_json rescue value
    @redis.set(key.to_s, val)
  end
  alias_method :[]=, :set

  def size
    @redis.info["db0"].match(/keys=(\d)/)[1].to_i
  end
end
