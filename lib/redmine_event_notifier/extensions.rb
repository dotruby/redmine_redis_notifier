module RedmineEventNotifier
  module Extensions
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        has_many :event_notifications, as: :subject

        after_commit :save_create_event_notification, on: :create
        after_commit :save_update_event_notification, on: :update
        after_commit :save_destroy_event_notification, on: :destroy
      end
    end

    module InstanceMethods
      def save_create_event_notification
        EventNotification.track("create", self)
      end

      def save_update_event_notification
        EventNotification.track("update", self) if self.previous_changes.present?
      end

      def save_destroy_event_notification
        EventNotification.track("destroy", self)
      end
    end
  end
end

[Issue, Group, Project, Role, TimeEntry, User].each do |redmine_model|
  unless redmine_model.included_modules.include?(RedmineEventNotifier::Extensions)
    redmine_model.send(:include, RedmineEventNotifier::Extensions)
  end
end
