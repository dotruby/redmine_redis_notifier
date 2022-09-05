require "redmine"

require_relative 'lib/redmine_redis_notifier'

Redmine::Plugin.register :redmine_redis_notifier do
  name "Redmine Redis Notifier"
  author "DotRuby GmbH"
  description "Redmine Plugin to publish object events to Redis for PubSub usage"
  version "0.2.0"
  url "https://github.com/dotruby/redmine_redis_notifier"
  author_url "https://www.dotruby.com/"
  requires_redmine version_or_higher: "4.2.7"

  settings partial: "settings/redmine_redis_notifier", default: {
    "enable_issues" => "1",
    "enable_groups" => "1",
    "enable_members" => "1",
    "enable_member_roles" => "1",
    "enable_projects" => "1",
    "enable_roles" => "1",
    "enable_time_entries" => "1",
    "enable_users" => "1"
  }

  menu :admin_menu, :redis_notifications, {controller: "redis_notifications", action: "index"}, caption: "Redis Notifications", last: true, html: {class: "icon icon-message"}
end
