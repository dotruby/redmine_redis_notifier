module RedmineEventNotifier
  module Extensions
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        after_commit :create_event_notification, on: :create
      end
    end

    module InstanceMethods
      def create_event_notification
        EventNotification.create(event: self.class.name, topic: "test")
      end
    end
  end
end

unless Project.included_modules.include?(RedmineEventNotifier::Extensions)
  Project.send(:include, RedmineEventNotifier::Extensions)
end