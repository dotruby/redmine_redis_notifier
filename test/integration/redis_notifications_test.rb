require "test_helper"

class RedisNotificationsTest < Redmine::IntegrationTest
  fixtures :projects, :users

  setup do
    users(:users_001)
    log_user("admin", "admin")
    @project = projects(:projects_001)
    RedisNotification.create!(action: "update", subject: @project)
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

  # TODO
end
