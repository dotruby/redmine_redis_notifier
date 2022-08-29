Rails.configuration.to_prepare do
  # link patches
  require 'redmine_event_notifier/extensions'
end

module RedmineEventNotifier
end