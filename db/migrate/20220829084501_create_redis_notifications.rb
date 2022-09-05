class CreateRedisNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :redis_notifications do |t|
      t.string :action
      t.references :subject, polymorphic: true
      t.datetime :published_at
      t.bigint :current_user_id
      t.text :error
      t.datetime :created_at
    end
  end
end
