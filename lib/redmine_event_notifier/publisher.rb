module RedmineEventNotifier
  class Publisher
    attr_accessor :event_notification
    delegate :subject, :subject_id, :subject_type, :current_user_id, to: :event_notification, allow_nil: true

    def initialize(event_notification)
      self.event_notification = event_notification
    end

    def publish
      begin
        redis.publish event_name, json_data
        event_notification.update_columns(published_at: Time.zone.now, error: nil)
      rescue Redis::ConnectionError, Redis::CannotConnectError => e
        event_notification.update_columns(published_at: nil, error: "Could not create Redis Connection: #{e.message}")
      rescue StandardError => e
        event_notification.update_columns(published_at: nil, error: e.message)
      end
    end

    def event_name
      "redmine/event_notifications/#{event_notification.subject_type.underscore.pluralize}/#{event_notification.action}"
    end

    private

    def redis
      RedmineEventNotifier.redis
    end

    def subject_data
      {id: subject_id, current_user_id: current_user_id}
    end

    def json_data
      subject_data.to_json
    end
  end
end
