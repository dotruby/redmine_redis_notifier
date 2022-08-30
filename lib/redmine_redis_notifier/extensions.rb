module RedmineRedisNotifier
  module Extensions
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        has_many :redis_notifications, as: :subject

        after_commit :save_create_redis_notification, on: :create
        after_commit :save_update_redis_notification, on: :update
        after_commit :save_destroy_redis_notification, on: :destroy
      end
    end

    module InstanceMethods
      def save_create_redis_notification
        RedisNotification.track("create", self)
      end

      def save_update_redis_notification
        RedisNotification.track("update", self) if self.previous_changes.present?
      end

      def save_destroy_redis_notification
        RedisNotification.track("destroy", self)
      end
    end
  end
end

[Issue, Group, Project, Role, TimeEntry, User].each do |redmine_model|
  unless redmine_model.included_modules.include?(RedmineRedisNotifier::Extensions)
    redmine_model.send(:include, RedmineRedisNotifier::Extensions)
  end
end
