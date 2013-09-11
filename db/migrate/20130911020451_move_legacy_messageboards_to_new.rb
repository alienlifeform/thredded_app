class MoveLegacyMessageboardsToNew < ActiveRecord::Migration
  def up
    remove_index :messageboards, [:name, :site_id]
    change_column_null :messageboards, :name, false
    rename_column :messageboards, :title, :slug
    rename_table :thredded_messageboards, :new_thredded_messageboards
    rename_table :messageboards, :thredded_messageboards
  end

  def down
    rename_table :thredded_messageboards, :messageboards
    rename_table :new_thredded_messageboards, :thredded_messageboards
    rename_column :messageboards, :slug, :title
    change_column_null :messageboards, :name, true
    add_index :messageboards, [:name, :site_id], unique: true
  end
end
