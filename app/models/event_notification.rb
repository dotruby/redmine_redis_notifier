class EventNotification < ActiveRecord::Base
  # associations
  #
  #

  belongs_to :owner, polymorphic: true
  belongs_to :current_user, optional: true, class_name: "User"

  # validations
  #
  #

  validates :action, presence: true

  # callbacks
  #
  #

  after_commit :publish_event, on: :create

  def publish_event
    RedmineEventNotifier::Publisher.new(self).publish
  end

  # class methods
  #
  #

  def self.track(action, owner)
    owner_type = if owner.is_a?(Group)
      "Group"
    elsif owner.is_a?(User)
      "User"
    else
      owner.class.name
    end

    if Setting.plugin_redmine_event_notifier["enable_#{owner_type.underscore.pluralize}"] == "1"
      EventNotification.create(action: action, owner_id: owner.id, owner_type: owner_type, current_user_id: User&.current&.id)
    end
  end
end
