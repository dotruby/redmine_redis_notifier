class EventNotificationsController < ApplicationController
  before_action :require_admin

  def index
    @event_notifications = EventNotification.all
  end
end
