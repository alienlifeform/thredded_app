class MoveLegacyMessageboardsToNew < ActiveRecord::Migration
  def change
    change_column_null :messageboards, :name, false
    rename_column :messageboards, :title, :slug
    rename_table :thredded_messageboards, :new_thredded_messageboards
    rename_table :messageboards, :thredded_messageboards
  end
end
