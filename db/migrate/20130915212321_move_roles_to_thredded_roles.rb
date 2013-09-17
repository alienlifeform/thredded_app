class MoveRolesToThreddedRoles < ActiveRecord::Migration
  def up
    remove_index :roles, [:messageboard_id, :last_seen]
    add_index :roles, :messageboard_id
    rename_table :thredded_roles, :new_thredded_roles
    rename_table :roles, :thredded_roles
  end

  def down
    rename_table :thredded_roles, :roles
    rename_table :new_thredded_roles, :thredded_roles
    remove_index :roles, :messageboard_id
    add_index :roles, [:messageboard_id, :last_seen]
  end
end
