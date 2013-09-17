class CopyUserDataToThreddedUserDetails < ActiveRecord::Migration
  def up
    execute <<-eosql
      INSERT INTO thredded_user_details( user_id,
          latest_activity_at,
          posts_count,
          topics_count,
          superadmin,
          created_at,
          updated_at )
      SELECT id,
        last_sign_in_at,
        posts_count,
        topics_count,
        superadmin,
        created_at,
        updated_at
      FROM users
    eosql
  end

  def down
    execute 'DELETE FROM thredded_user_details'
  end
end
