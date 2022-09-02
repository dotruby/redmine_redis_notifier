require "test_helper"

class WorkingTest < Redmine::IntegrationTest
  fixtures :projects, :users

  setup do
    @admin_user = users(:users_001)
    log_user("admin", "admin")
  end

  # Project actions
  #
  #

  test "on project creation it creates a redis notification" do
    project_identifier = SecureRandom.hex(6)
    post projects_path, params: { project: { name: "My new project", identifier: project_identifier } }
    project = Project.find_by!(identifier: project_identifier)
    assert RedisNotification.find_by(action: "create", subject: project).present?
  end

  test "on project update it creates a redis notification" do
    project = projects(:projects_001)
    put project_path(project), params: { project: { name: "New Name" } }
    project.reload
    assert RedisNotification.find_by(action: "update", subject: project).present?
  end

  test "on project deletion it creates a redis notification" do
    project = Project.create(name: "Test Project", identifier: SecureRandom.hex(6) )
    delete project_path(project, confirm: project.identifier)
    assert RedisNotification.find_by(action: "destroy", subject_id: project.id).present?
  end

  test "on project archive it creates a redis notification" do
    project = Project.create(name: "Test Project", identifier: SecureRandom.hex(6) )
    post archive_project_path(project)
    assert RedisNotification.find_by(action: "archive", subject: project).present?
  end

  test "on project unarchive it creates a redis notification" do
    project = Project.create(name: "Test Project", identifier: SecureRandom.hex(6), status: Project::STATUS_ARCHIVED )
    post unarchive_project_path(project)
    assert RedisNotification.find_by(action: "unarchive", subject: project).present?
  end

  # TODO

  # Group actions
  #
  #

  # Issue actions
  #
  #

  # Member actions
  #
  #

  # Role actions
  #
  #

  # TimeEvent actions
  #
  #

  # User actions
  #
  #

end
