class CreateEventNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :event_notifications do |t|
      t.string :action
      t.references :owner, polymorphic: true
      t.datetime :sent_at
      t.bigint :current_user_id
      t.text :error
      t.datetime :created_at
    end
  end
end
