class MoveImagesToThreddedImages < ActiveRecord::Migration
  def up
    change_column_null :images, :created_at, :false
    change_column_null :images, :updated_at, :false
    rename_table :thredded_images, :new_thredded_images
    rename_table :images, :thredded_images
  end

  def down
    rename_table :thredded_images, :images
    rename_table :new_thredded_images, :thredded_images
    change_column_null :images, :updated_at, :true
    change_column_null :images, :created_at, :true
  end
end
