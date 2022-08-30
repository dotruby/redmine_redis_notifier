require File.expand_path('../../test_helper', __FILE__)

class EventNotificationTest < ActiveSupport::TestCase
  fixtures :projects

  # validations
  #
  #

  test "validates presence of action attribute" do
    assert_equal EventNotification.new.valid?, false
    assert_equal EventNotification.new(action: "create").valid?, true
  end

  # class methods
  #
  #

  test "tracking with settings enabled saves a event notification" do
    result = EventNotification.track("update", projects(:projects_001))
    assert_equal EventNotification.last, result
  end

  test "tracking with settings disabeld does not save an event notification" do
    Setting.plugin_redmine_event_notifier["enable_projects"] = "0"
    assert_equal EventNotification.track("update", projects(:projects_001)), true
  end
end
