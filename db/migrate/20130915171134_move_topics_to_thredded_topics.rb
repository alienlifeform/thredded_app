class MoveTopicsToThreddedTopics < ActiveRecord::Migration
  def up
    remove_index :topics, [:messageboard_id, :updated_at]
    change_column_null :topics, :updated_at, :false
    change_column_null :topics, :created_at, :false
    change_column_null :topics, :slug, :false
    change_column_default :topics, :locked, false
    rename_table :thredded_topics, :new_thredded_topics
    rename_table :topics, :thredded_topics
  end

  def down
    rename_table :thredded_topics, :topics
    rename_table :new_thredded_topics, :thredded_topics
    change_column_default :topics, :locked, nil
    change_column_null :topics, :slug, :true
    change_column_null :topics, :created_at, :true
    change_column_null :topics, :updated_at, :true
    add_index :topics, [:messageboard_id, :updated_at]
  end
end
