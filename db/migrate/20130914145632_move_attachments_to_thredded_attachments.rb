class MoveAttachmentsToThreddedAttachments < ActiveRecord::Migration
  def up
    change_column_null :attachments, :created_at, :false
    change_column_null :attachments, :updated_at, :false
    rename_table :thredded_attachments, :new_thredded_attachments
    rename_table :attachments, :thredded_attachments
  end

  def down
    rename_table :thredded_attachments, :attachments
    rename_table :new_thredded_attachments, :thredded_attachments
    change_column_null :attachments, :updated_at, :true
    change_column_null :attachments, :created_at, :true
  end
end
