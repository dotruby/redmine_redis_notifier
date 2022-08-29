module RedmineEventNotifier
  class Publisher
    attr_accessor :event_notification
    delegate :owner, :owner_id, :owner_type, :current_user_id, to: :event_notification, allow_nil: true

    def initialize(event_notification)
      self.event_notification = event_notification
    end

    def publish
      # if you want to suscribe to the events you can e.g. use this
      # Easily subscribe to this pattern in redis-cli: PSUBSCRIBE redmine/event_notifications/*

      begin
        redis.publish event_name, json_data
        event_notification.update_column(:sent_at, Time.zone.now)
      rescue Redis::ConnectionError => e
        event_notification.update_column(:error, "Could not create Redis Connection: #{e.message}")
      end
    end

    def event_name
      "redmine/event_notifications/#{event_notification.owner_type.underscore.pluralize}/#{event_notification.action}"
    end

    private

    def redis
      RedmineEventNotifier.redis
    end

    def owner_data
      case owner_type
      when Project
        {id: owner_id, identifier: owner.identifier, current_user_id: current_user_id}
      else
        {id: owner_id, current_user_id: current_user_id}
      end
    end

    def json_data
      owner_data.to_json
    end
  end
end
