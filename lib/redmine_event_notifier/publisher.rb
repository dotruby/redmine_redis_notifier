module RedmineEventNotifier
  class Publisher
    attr_accessor :event_notification
    delegate :owner, :owner_id, :owner_type, to: :event_notification, allow_nil: true

    def initialize(event_notification)
      self.event_notification = event_notification
    end

    def publish
      # if you want to suscribe to the events you can e.g. use this
      # Easily subscribe to this pattern in redis-cli: PSUBSCRIBE redmine/event_notifications/*

      redis.publish event_name, {id: event_notification.owner_id}.to_json
    end

    def event_name
      "redmine/event_notifications/#{event_notification.owner_type.underscore.pluralize}/#{event_notification.action}"
    end

    private

    def redis
      RedmineEventNotifier.redis
    end

    def owner_based_data
      case owner_type
      when Project
        {id: owner_id, identifier: owner.identifier}
      else
        {id: owner_id}
      end
    end
  end
end
