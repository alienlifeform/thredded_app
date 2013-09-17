class MoveCategoriesToThreddedCategories < ActiveRecord::Migration
  def up
    change_column_null :categories, :messageboard_id, :false
    change_column_null :categories, :name, :false
    change_column_null :categories, :created_at, :false
    change_column_null :categories, :updated_at, :false
    rename_table :thredded_categories, :new_thredded_categories
    rename_table :categories, :thredded_categories
  end

  def down
    rename_table :thredded_categories, :categories
    rename_table :new_thredded_categories, :thredded_categories
    change_column_null :categories, :updated_at, :true
    change_column_null :categories, :created_at, :true
    change_column_null :categories, :name, :false
    change_column_null :categories, :messageboard_id, :false
  end
end
