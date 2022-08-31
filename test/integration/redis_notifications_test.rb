require "test_helper"

class RedisNotificationsTest < Redmine::IntegrationTest
  fixtures :projects, :users

  setup do
    users(:users_001)
    log_user("admin", "admin")
    @project = projects(:projects_001)
    @redis_notification = RedisNotification.create!(action: "update", subject: @project)
  end

  # Index action
  #
  #

  test "successfully renders the index page with html format" do
    get redis_notifications_path
    assert_response :success
  end

  test "successfully renders the index page with json format" do
    get redis_notifications_path(format: "json")
    assert_response :success
  end

  test "successfully renders the index page with xml format" do
    get redis_notifications_path(format: "xml")
    assert_response :success
  end

  test "it displays the project as an redis notification on the index page with html format" do
    get redis_notifications_path
    assert_match @project.name, response.body
  end

  # show action
  #
  #

  test "successfully renders the show page with html format" do
    get redis_notification_path(@redis_notification)
    assert_response :success
  end

  test "successfully renders the show page with json format" do
    get redis_notification_path(@redis_notification, format: "json")
    assert_response :success
  end

  test "successfully renders the show page with xml format" do
    get redis_notification_path(@redis_notification, format: "xml")
    assert_response :success
  end

  test "it displays the project as an redis notification on the show page with html format" do
    get redis_notification_path(@redis_notification)
    assert_match @project.name, response.body
  end

  # publish action
  #
  #

  test "on #publish it redirects to the overview path" do
    put publish_redis_notification_path(@redis_notification)
    assert_redirected_to redis_notifications_path
  end
end
