class MovePreferencesToThreddedMessageboardPreferences < ActiveRecord::Migration
  def up
    change_column_default :preferences, :notify_on_mention, true
    change_column_default :preferences, :notify_on_message, true
    add_column :preferences, :filter, :string, default: 'markdown', null: false
    rename_table :thredded_messageboard_preferences,
      :new_thredded_messageboard_preferences
    rename_table :preferences, :thredded_messageboard_preferences
  end

  def down
    rename_table :thredded_messageboard_preferences, :preferences
    rename_table :new_thredded_messageboard_preferences,
      :thredded_messageboard_preferences
    remove_column :preferences, :filter
    change_column_default :preferences, :notify_on_message, false
    change_column_default :preferences, :notify_on_mention, false
  end
end
