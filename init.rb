require "redmine"

Rails.configuration.to_prepare do
  require "redmine_event_notifier/extensions"
end

Redmine::Plugin.register :redmine_event_notifier do
  name "Redmine Event Notifier"
  author "DotRuby GmbH"
  description "Redmine Plugin to publish object events to Redis for PubSub usage"
  version "0.0.1"
  url "https://github.com/dotruby/redmine_event_notifier"
  author_url "https://www.dotruby.com/"
  requires_redmine version_or_higher: "5.0.0"
  settings partial: "settings/redmine_event_notifier", default: {
    "redmine_event_notifier_issues" => "1",
    "redmine_event_notifier_groups" => "1",
    "redmine_event_notifier_projects" => "1",
    "redmine_event_notifier_roles" => "1",
    "redmine_event_notifier_time_entries" => "1",
    "redmine_event_notifier_users" => "1"
  }
  menu :admin_menu, :event_notifications, {controller: "event_notifications", action: "index"}, caption: "Event Notifications", last: true, html: {class: "icon icon-message"}
end
