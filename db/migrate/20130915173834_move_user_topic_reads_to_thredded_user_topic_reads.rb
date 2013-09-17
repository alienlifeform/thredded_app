class MoveUserTopicReadsToThreddedUserTopicReads < ActiveRecord::Migration
  def up
    rename_table :thredded_user_topic_reads, :new_thredded_user_topic_reads
    rename_table :user_topic_reads, :thredded_user_topic_reads
  end

  def down
    rename_table :thredded_user_topic_reads, :user_topic_reads
    rename_table :new_thredded_user_topic_reads, :thredded_user_topic_reads
  end
end
