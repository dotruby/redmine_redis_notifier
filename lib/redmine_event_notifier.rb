Rails.configuration.to_prepare do
  # require redis
  require "redis"

  # link patches
  require 'redmine_event_notifier/extensions'
end

module RedmineEventNotifier
  def self.redis
    @redis ||= if ENV["REDIS_URL"].present?
      Redis.new(url: ENV["REDIS_URL"])
    else
      Redis.new
    end
  end
end
