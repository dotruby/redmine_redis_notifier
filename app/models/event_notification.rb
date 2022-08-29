class EventNotification < ActiveRecord::Base
  EVENTS = ["group", "issue", "project", "role", "time_entry", "user"].freeze

  # validations
  #
  #

  validates :event, presence: true
  validates :topic, presence: true

  # callbacks
  #
  #

  after_commit :publish_event, on: :create

  def publish_event
    # EventPublisher.send(self)

    puts "--------------------------"
    puts "Publish Event!"
    puts "--------------------------"
  end
end
