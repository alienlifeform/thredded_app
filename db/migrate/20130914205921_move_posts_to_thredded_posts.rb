class MovePostsToThreddedPosts < ActiveRecord::Migration
  def up
    change_column_default :posts, :filter, 'markdown'
    change_column_null :posts, :topic_id, :false
    change_column_null :posts, :messageboard_id, :false
    change_column_null :posts, :created_at, :false
    change_column_null :posts, :updated_at, :false
    rename_table :thredded_posts, :new_thredded_posts
    rename_table :posts, :thredded_posts
  end

  def down
    rename_table :thredded_posts, :posts
    rename_table :new_thredded_posts, :thredded_posts
    change_column_null :posts, :updated_at, :true
    change_column_null :posts, :created_at, :true
    change_column_null :posts, :messageboard_id, :false
    change_column_null :posts, :topic_id, :false
    change_column_default :posts, :filter, 'bbcode'
  end
end
