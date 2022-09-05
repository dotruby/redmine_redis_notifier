require File.expand_path('../../test_helper', __FILE__)

class RedisNotificationTest < ActiveSupport::TestCase
  fixtures :projects

  # validations
  #
  #

  test "validates presence of action attribute" do
    assert_equal RedisNotification.new.valid?, false
    assert_equal RedisNotification.new(action: "create").valid?, true
  end

  # class methods
  #
  #

  test "tracking with settings enabled saves a redis notification" do
    Setting.plugin_redmine_redis_notifier["enable_projects"] = "1"
    result = RedisNotification.track("update", projects(:projects_001))
    assert_equal RedisNotification.last, result
  end

  test "tracking with settings disabeld does not save a redis notification" do
    Setting.plugin_redmine_redis_notifier["enable_projects"] = "0"
    assert_equal RedisNotification.track("update", projects(:projects_001)), true
  end
end
