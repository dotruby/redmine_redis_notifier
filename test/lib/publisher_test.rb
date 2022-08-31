require File.expand_path('../../test_helper', __FILE__)

class PublisherTest < ActiveSupport::TestCase
  fixtures :projects

  test "creates a correct channel name for create action" do
    redis_notification = RedisNotification.create!(action: "create", subject: projects(:projects_001))
    expected_channel_name = "redmine/redis_notifications/projects/create"
    actual_channel_name = RedmineRedisNotifier::Publisher.new(redis_notification).channel_name
    assert_equal expected_channel_name, actual_channel_name
  end

  test "creates a correct channel name for update action" do
    redis_notification = RedisNotification.create!(action: "update", subject: projects(:projects_001))
    expected_channel_name = "redmine/redis_notifications/projects/update"
    actual_channel_name = RedmineRedisNotifier::Publisher.new(redis_notification).channel_name
    assert_equal expected_channel_name, actual_channel_name
  end

  test "creates a correct channel name for destroy action" do
    redis_notification = RedisNotification.create!(action: "destroy", subject: projects(:projects_001))
    expected_channel_name = "redmine/redis_notifications/projects/destroy"
    actual_channel_name = RedmineRedisNotifier::Publisher.new(redis_notification).channel_name
    assert_equal expected_channel_name, actual_channel_name
  end

  test "on successful publish it writes the published_at timestamp" do
    Redis.any_instance.stubs(:publish).returns(true)
    redis_notification = RedisNotification.create!(action: "create", subject: projects(:projects_001))
    RedmineRedisNotifier::Publisher.new(redis_notification).publish
    assert redis_notification.reload.published_at
  end

  test "on redis connection error it wirtes the errors attribute" do
    Redis.any_instance.stubs(:publish).raises(Redis::ConnectionError)
    redis_notification = RedisNotification.create!(action: "create", subject: projects(:projects_001))
    RedmineRedisNotifier::Publisher.new(redis_notification).publish
    assert redis_notification.reload.error?
  end

  test "on standard error it wirtes the errors attribute" do
    Redis.any_instance.stubs(:publish).raises(StandardError)
    redis_notification = RedisNotification.create!(action: "create", subject: projects(:projects_001))
    RedmineRedisNotifier::Publisher.new(redis_notification).publish
    assert redis_notification.reload.error?
  end
end
