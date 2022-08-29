class EventNotification < ActiveRecord::Base
  EVENTS = ["group", "issue", "project", "role", "time_entry", "user"].freeze

  # associations
  #
  #

  belongs_to :owner, polymorphic: true

  # validations
  #
  #

  validates :event, presence: true
  validates :action, presence: true

  # callbacks
  #
  #

  after_commit :publish_event, on: :create

  def publish_event
    # EventPublisher.send(self)

    puts "--------------------------"
    puts "#{event} -- #{action}!"
    puts "--------------------------"

    event_name = "redmine/event_notifications/#{event.underscore.pluralize}/#{action}"

    # Easily subscribe to this pattern in redis-cli with "PSUBSCRIBE redmine/event_notifications/*"
    RedmineEventNotifier.redis.publish "redmine/event_notifications/#{event.underscore.pluralize}/#{action}", {id: self.owner_id}.to_json
  end
end
