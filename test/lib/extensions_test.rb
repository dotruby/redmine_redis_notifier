require File.expand_path('../../test_helper', __FILE__)

class ExtensionsTest < ActiveSupport::TestCase
  test "extension is correctly loaded in relevant models" do
    RedmineRedisNotifier::Extensions.models.each do |redmine_model|
      assert redmine_model.new.respond_to?(:redis_notifications)
    end
  end

  test "if object creation fails, no redis_notification is created" do
    assert_no_difference -> { RedisNotification.count } do
      Project.create(name: "Test Project")
    end
  end

  test "on object creation a redis_notification is created" do
    assert_difference -> { RedisNotification.where(action: "create", subject_type: "Project").count } do
      Project.create!(name: "Test Project", identifier: SecureRandom.hex(8))
    end
  end

  test "on object update a redis_notification is created" do
    project = Project.create!(name: "Test Project", identifier: SecureRandom.hex(8))

    assert_difference -> { RedisNotification.where(action: "update", subject: project).count } do
      project.name = "New Name"
      project.save!
    end
  end

  test "on object destroy a redis_notification is created" do
    project = Project.create!(name: "Test Project", identifier: SecureRandom.hex(8))

    assert_difference -> { RedisNotification.where(action: "destroy", subject_type: "Project", subject_id: project.id).count } do
      project.destroy
    end
  end
end
