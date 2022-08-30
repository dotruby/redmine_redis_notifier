class EventNotificationsController < ApplicationController
  self.main_menu = false
  before_action :require_admin_or_api_request
  accept_api_auth :index, :show

  def index
    scope = EventNotification.includes(:current_user, :subject).order(id: :desc)

    respond_to do |format|
      format.html do
        @event_notification_count = scope.count
        @event_notification_pages = Paginator.new @event_notification_count, per_page_option, params['page']
        @event_notifications = scope.limit(@event_notification_pages.per_page).offset(@event_notification_pages.offset).to_a
      end
      format.api do
        @offset, @limit = api_offset_and_limit
        @event_notification_count = scope.count
        @event_notifications = scope.offset(@offset).limit(@limit).to_a
      end
    end
  end

  def show
    resource
    respond_to do |format|
      format.html
      format.api
    end
  end

  def publish
    resource.publish
    flash[:notice] = "Event Notification ##{resource.id} has been published."
    redirect_to_referer_or(event_notifications_path)
  end

  private

  def resource
    @event_notification ||= EventNotification.find(params[:id])
  end
end
