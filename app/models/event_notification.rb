class EventNotification < ActiveRecord::Base
  ACTIONS = ["create", "update", "destroy"].freeze

  # associations
  #
  #

  belongs_to :owner, polymorphic: true
  belongs_to :current_user, optional: true

  # validations
  #
  #

  validates :action, presence: true, inclusion: {in: ACTIONS}

  # callbacks
  #
  #

  after_commit :publish_event, on: :create

  def publish_event
    RedmineEventNotifier::Publisher.new(self).publish
  end
end
