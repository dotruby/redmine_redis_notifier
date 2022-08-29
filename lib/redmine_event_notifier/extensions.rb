module RedmineEventNotifier
  module Extensions
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        has_many :event_notifications, as: :owner, dependent: :destroy

        after_commit :save_create_event_notification, on: :create
        after_commit :save_update_event_notification, on: :update
        after_commit :save_destroy_event_notification, on: :destroy
      end
    end

    module InstanceMethods
      def save_create_event_notification
        EventNotification.create(action: "create", owner: self)
      end

      def save_update_event_notification
        EventNotification.create(action: "update", owner: self)
      end

      def save_destroy_event_notification
        EventNotification.create(action: "destroy", owner: self)
      end
    end
  end
end

[User, Group, Issue, Project, TimeEntry].each do |redmine_model|
  unless redmine_model.included_modules.include?(RedmineEventNotifier::Extensions)
    redmine_model.send(:include, RedmineEventNotifier::Extensions)
  end
end
