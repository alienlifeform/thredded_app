class MovePrivateUsersToThreddedPrivateUsers < ActiveRecord::Migration
  def up
    change_column_null :private_users, :updated_at, :false
    change_column_null :private_users, :created_at, :false
    rename_table :thredded_private_users, :new_thredded_private_users
    rename_table :private_users, :thredded_private_users
  end

  def down
    rename_table :thredded_private_users, :private_users
    rename_table :new_thredded_private_users, :thredded_private_users
    change_column_null :private_users, :created_at, :true
    change_column_null :private_users, :updated_at, :true
  end
end
