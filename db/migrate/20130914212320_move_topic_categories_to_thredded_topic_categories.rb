class MoveTopicCategoriesToThreddedTopicCategories < ActiveRecord::Migration
  def up
    rename_table :thredded_topic_categories, :new_thredded_topic_categories
    rename_table :topic_categories, :thredded_topic_categories
  end

  def down
    rename_table :thredded_topic_categories, :topic_categories
    rename_table :new_thredded_topic_categories, :thredded_topic_categories
  end
end
