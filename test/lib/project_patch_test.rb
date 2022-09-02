require File.expand_path('../../test_helper', __FILE__)

class ProjectPatchTest < ActiveSupport::TestCase
  test "with overwrite project is still correctly archived" do
    project = Project.create!(name: "Test Project", identifier: SecureRandom.hex(8))
    project.archive
    assert project.archived?
  end

  test "on project archive call, a redis notification is created" do
    project = Project.create!(name: "Test Project", identifier: SecureRandom.hex(8))
    project_scope = RedisNotification.where(action: "archive", subject: project)

    assert_difference "project_scope.count" do
      project.archive
      project.reload
    end
  end

  test "with overwrite project is still correctly unarchived" do
    project = Project.create!(name: "Test Project", identifier: SecureRandom.hex(8), status: Project::STATUS_ARCHIVED)
    project.unarchive
    assert project.status == Project::STATUS_ACTIVE
  end

  test "on project unarchive call, a redis notification is created" do
    project = Project.create!(name: "Test Project", identifier: SecureRandom.hex(8), status: Project::STATUS_ARCHIVED)
    project_scope = RedisNotification.where(action: "unarchive", subject: project)

    assert_difference "project_scope.count" do
      project.unarchive
      project.reload
    end
  end
end
