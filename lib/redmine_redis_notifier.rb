# load dependencies
require "redis"

# plugin functionality
require_relative "redmine_redis_notifier/extensions"
require_relative "redmine_redis_notifier/project_patch"
require_relative "redmine_redis_notifier/publisher"

module RedmineRedisNotifier
  def self.redis
    @redis ||= if ENV["REDIS_URL"].present?
      Redis.new(url: ENV["REDIS_URL"])
    else
      Redis.new
    end
  end
end
