module RedmineRedisNotifier
  class Publisher
    attr_accessor :redis_notification
    delegate :subject, :subject_id, :subject_type, :current_user_id, to: :redis_notification, allow_nil: true

    def initialize(redis_notification)
      self.redis_notification = redis_notification
    end

    def publish
      begin
        redis.publish channel_name, json_data
        redis_notification.update_columns(published_at: Time.zone.now, error: nil)
      rescue Redis::ConnectionError, Redis::CannotConnectError => e
        redis_notification.update_columns(published_at: nil, error: "Could not create Redis Connection: #{e.message}")
      rescue StandardError => e
        redis_notification.update_columns(published_at: nil, error: e.message)
      end
    end

    def channel_name
      "redmine/redis_notifications/#{redis_notification.subject_type.underscore.pluralize}/#{redis_notification.action}"
    end

    private

    def redis
      RedmineRedisNotifier.redis
    end

    def subject_data
      {id: subject_id, current_user_id: current_user_id}
    end

    def json_data
      subject_data.to_json
    end
  end
end
