class RenameTopicsTypeForNewPrivateTopics < ActiveRecord::Migration
  def up
    execute "UPDATE thredded_topics SET type='Thredded::PrivateTopic' where type='PrivateTopic'"
  end

  def down
    execute "UPDATE thredded_topics SET type='PrivateTopic' where type='Thredded::PrivateTopic'"
  end
end
