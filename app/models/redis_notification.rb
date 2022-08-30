class RedisNotification < ActiveRecord::Base
  # associations
  #
  #

  belongs_to :subject, polymorphic: true
  belongs_to :current_user, optional: true, class_name: "User"

  # validations
  #
  #

  validates :action, presence: true

  # callbacks
  #
  #

  after_commit :publish, on: :create

  # class methods
  #
  #

  def self.track(action, subject)
    subject_type = if subject.is_a?(Group)
      "Group"
    elsif subject.is_a?(User)
      "User"
    else
      subject.class.name
    end

    if Setting.plugin_redmine_redis_notifier["enable_#{subject_type.underscore.pluralize}"] == "1"
      RedisNotification.create(action: action, subject_id: subject.id, subject_type: subject_type, current_user_id: User&.current&.id)
    else
      true
    end
  end

  # instance methods
  #
  #

  def publish
    RedmineRedisNotifier::Publisher.new(self).publish
  end
end
