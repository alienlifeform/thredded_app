class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :images, :post_id
    add_index :messageboards, :name
    add_index :posts, :user_id
    add_index :posts, :messageboard_id
    add_index :private_users, :user_id
    add_index :topic_categories, :category_id
    add_index :topics, :messageboard_id
  end
end
