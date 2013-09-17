class CopyUserDataToThreddedUserPreferences < ActiveRecord::Migration
  def up
    execute <<-eosql
      INSERT INTO thredded_user_preferences( user_id,
          time_zone,
          created_at,
          updated_at )
      SELECT id,
        time_zone,
        created_at,
        updated_at
      FROM users
    eosql
  end

  def down
    execute 'DELETE FROM thredded_user_preferences'
  end
end
