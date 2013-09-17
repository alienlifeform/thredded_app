class MovePostNotificationsToThreddedPostNotifications < ActiveRecord::Migration
  def up
    rename_table :thredded_post_notifications, :new_thredded_post_notifications
    rename_table :post_notifications, :thredded_post_notifications
  end

  def down
    rename_table :thredded_post_notifications, :post_notifications
    rename_table :new_thredded_post_notifications, :thredded_post_notifications
  end
end
