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

  # attributes
  #
  #

  serialize :additional_data, JSON

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

    if Setting.plugin_redmine_redis_notifier["enable_#{subject_type.underscore.pluralize}"] == "1" && notification_table_exists?
      attributes = {
        action: action,
        subject_id: subject.id,
        subject_type: subject_type,
        current_user_id: User&.current&.id
      }

      ['project_id', 'issue_id', 'user_id', 'member_id', 'role_id'].each do |attribute|
        if subject.has_attribute?(attribute)
          attributes[:additional_data] = Hash(attributes[:additional_data]).merge({attribute.to_sym => subject.send(attribute)})
        end
      end

      create(attributes)
    else
      true
    end
  end

  def self.notification_table_exists?
    ActiveRecord::Base.connection.table_exists?("redis_notifications")
  end

  # instance methods
  #
  #

  def publish
    RedmineRedisNotifier::Publisher.new(self).publish
  end
end
