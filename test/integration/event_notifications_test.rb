require "test_helper"

class EventNotificationsTest < Redmine::IntegrationTest
  fixtures :projects

  setup do
    log_user("admin", "admin")
    @project = projects(:projects_001)
    EventNotification.create!(action: "update", subject: @project)
  end

  # Index action
  #
  #

  test "successfully renders the index page with html format" do
    get event_notifications_path
    assert_response :success
  end

  test "successfully renders the index page with json format" do
    get event_notifications_path(format: "json")
    assert_response :success
  end

  test "successfully renders the index page with xml format" do
    get event_notifications_path(format: "xml")
    assert_response :success
  end

  test "it displays the project as an event notification on the index page with html format" do
    get event_notifications_path
    assert_match @project.name, response.body
  end

  # show action
  #
  #

  # TODO
end
