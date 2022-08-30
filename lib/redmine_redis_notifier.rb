module RedmineRedisNotifier
  def self.redis
    @redis ||= if ENV["REDIS_URL"].present?
      Redis.new(url: ENV["REDIS_URL"])
    else
      Redis.new
    end
  end
end

Rails.configuration.to_prepare do
  # load dependencies
  require "redis"

  # plugin functionality
  require "redmine_redis_notifier/extensions"
  require "redmine_redis_notifier/project_patch"
  require "redmine_redis_notifier/publisher"
end
