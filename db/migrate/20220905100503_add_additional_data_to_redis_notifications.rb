class AddAdditionalDataToRedisNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :redis_notifications, :additional_data, :text
  end
end
