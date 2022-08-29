class EventNotificationsController < ApplicationController
  before_action :require_admin

  def index
    @event_notifications = EventNotification.all

    respond_to do |format|
      format.html do
        scope = EventNotification.all

        @event_notification_count = scope.count
        @event_notification_pages = Paginator.new @event_notification_count, per_page_option, params['page']
        @event_notifications = scope.limit(@event_notification_pages.per_page).offset(@event_notification_pages.offset).to_a
      end
    end
  end
end
