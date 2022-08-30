class RedisNotificationsController < ApplicationController
  self.main_menu = false
  before_action :require_admin_or_api_request
  accept_api_auth :index, :show

  def index
    scope = RedisNotification.includes(:current_user, :subject).order(id: :desc)

    respond_to do |format|
      format.html do
        @redis_notification_count = scope.count
        @redis_notification_pages = Paginator.new @redis_notification_count, per_page_option, params['page']
        @redis_notifications = scope.limit(@redis_notification_pages.per_page).offset(@redis_notification_pages.offset).to_a
      end
      format.api do
        @offset, @limit = api_offset_and_limit
        @redis_notification_count = scope.count
        @redis_notifications = scope.offset(@offset).limit(@limit).to_a
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
    flash[:notice] = "Redis Notification ##{resource.id} has been published."
    redirect_to_referer_or(redis_notifications_path)
  end

  private

  def resource
    @redis_notification ||= RedisNotification.find(params[:id])
  end
end
