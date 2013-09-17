# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130915215145) do

  create_table "app_configs", :force => true do |t|
    t.string "permission",           :default => "public"
    t.string "title"
    t.text   "description"
    t.string "email_from",           :default => "My Messageboard Mail-Bot <noreply@mysite.com>"
    t.string "email_subject_prefix", :default => "[My Messageboard] "
    t.string "incoming_email_host"
  end

  create_table "identities", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "identities", ["uid"], :name => "index_identities_on_uid"
  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "new_thredded_attachments", :force => true do |t|
    t.string   "attachment"
    t.string   "content_type"
    t.integer  "file_size"
    t.integer  "post_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "new_thredded_categories", :force => true do |t|
    t.integer  "messageboard_id", :null => false
    t.string   "name",            :null => false
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "new_thredded_images", :force => true do |t|
    t.integer  "post_id"
    t.integer  "width"
    t.integer  "height"
    t.string   "orientation"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "new_thredded_messageboard_preferences", :force => true do |t|
    t.boolean  "notify_on_mention", :default => true
    t.boolean  "notify_on_message", :default => true
    t.string   "filter",            :default => "markdown", :null => false
    t.integer  "user_id",                                   :null => false
    t.integer  "messageboard_id",                           :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "new_thredded_messageboard_preferences", ["messageboard_id"], :name => "index_thredded_messageboard_preferences_on_messageboard_id"
  add_index "new_thredded_messageboard_preferences", ["user_id"], :name => "index_thredded_messageboard_preferences_on_user_id"

  create_table "new_thredded_messageboards", :force => true do |t|
    t.string   "name",                                        :null => false
    t.string   "slug"
    t.text     "description"
    t.string   "security",           :default => "public"
    t.string   "posting_permission", :default => "anonymous"
    t.integer  "topics_count",       :default => 0
    t.integer  "posts_count",        :default => 0
    t.boolean  "closed",             :default => false,       :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "new_thredded_messageboards", ["closed"], :name => "index_thredded_messageboards_on_closed"

  create_table "new_thredded_post_notifications", :force => true do |t|
    t.string   "email",      :null => false
    t.integer  "post_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "new_thredded_posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_email"
    t.text     "content"
    t.string   "ip"
    t.string   "filter",          :default => "markdown"
    t.string   "source",          :default => "web"
    t.integer  "topic_id",                                :null => false
    t.integer  "messageboard_id",                         :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "new_thredded_roles", :force => true do |t|
    t.string   "level"
    t.integer  "user_id"
    t.integer  "messageboard_id"
    t.datetime "last_seen"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "new_thredded_roles", ["messageboard_id"], :name => "index_thredded_roles_on_messageboard_id"
  add_index "new_thredded_roles", ["user_id"], :name => "index_thredded_roles_on_user_id"

  create_table "new_thredded_topic_categories", :force => true do |t|
    t.integer "topic_id",    :null => false
    t.integer "category_id", :null => false
  end

  create_table "new_thredded_topics", :force => true do |t|
    t.integer  "user_id",                                 :null => false
    t.integer  "last_user_id",                            :null => false
    t.string   "title",                                   :null => false
    t.string   "slug",                                    :null => false
    t.integer  "messageboard_id",                         :null => false
    t.integer  "posts_count",     :default => 0
    t.string   "attribs",         :default => "[]"
    t.boolean  "sticky",          :default => false
    t.boolean  "locked",          :default => false
    t.string   "hash_id",                                 :null => false
    t.string   "state",           :default => "approved", :null => false
    t.string   "type"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "new_thredded_user_topic_reads", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.integer  "topic_id",                   :null => false
    t.integer  "post_id",                    :null => false
    t.integer  "posts_count", :default => 0, :null => false
    t.integer  "page",        :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "new_thredded_user_topic_reads", ["page"], :name => "index_thredded_user_topic_reads_on_page"
  add_index "new_thredded_user_topic_reads", ["post_id"], :name => "index_thredded_user_topic_reads_on_post_id"
  add_index "new_thredded_user_topic_reads", ["posts_count"], :name => "index_thredded_user_topic_reads_on_posts_count"
  add_index "new_thredded_user_topic_reads", ["topic_id"], :name => "index_thredded_user_topic_reads_on_topic_id"
  add_index "new_thredded_user_topic_reads", ["user_id"], :name => "index_thredded_user_topic_reads_on_user_id"

  create_table "private_users", :force => true do |t|
    t.integer  "private_topic_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "private_users", ["user_id", "private_topic_id"], :name => "index_private_users_on_user_id_and_private_topic_id"
  add_index "private_users", ["user_id"], :name => "index_private_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "thredded_attachments", :force => true do |t|
    t.string   "attachment"
    t.string   "content_type"
    t.integer  "file_size"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_attachments", ["post_id"], :name => "index_attachments_on_post_id"

  create_table "thredded_categories", :force => true do |t|
    t.integer  "messageboard_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_categories", ["messageboard_id"], :name => "index_categories_on_messageboard_id"

  create_table "thredded_images", :force => true do |t|
    t.integer  "width"
    t.integer  "height"
    t.string   "orientation"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thredded_images", ["post_id"], :name => "index_images_on_post_id"

  create_table "thredded_messageboard_preferences", :force => true do |t|
    t.boolean  "notify_on_mention", :default => true
    t.boolean  "notify_on_message", :default => true
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "user_id",                                   :null => false
    t.integer  "messageboard_id",                           :null => false
    t.string   "filter",            :default => "markdown", :null => false
  end

  add_index "thredded_messageboard_preferences", ["messageboard_id"], :name => "index_preferences_on_messageboard_id"
  add_index "thredded_messageboard_preferences", ["user_id"], :name => "index_preferences_on_user_id"

  create_table "thredded_messageboards", :force => true do |t|
    t.string   "name",                                        :null => false
    t.text     "description"
    t.string   "security",           :default => "public"
    t.string   "posting_permission", :default => "anonymous"
    t.integer  "site_id",            :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",       :default => 0
    t.integer  "posts_count",        :default => 0
    t.string   "slug"
    t.boolean  "closed",             :default => false,       :null => false
  end

  add_index "thredded_messageboards", ["closed"], :name => "index_messageboards_on_closed"
  add_index "thredded_messageboards", ["name"], :name => "index_messageboards_on_name"

  create_table "thredded_post_notifications", :force => true do |t|
    t.string   "email",      :null => false
    t.integer  "post_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "thredded_post_notifications", ["post_id"], :name => "index_post_notifications_on_post_id"

  create_table "thredded_posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_email"
    t.text     "content"
    t.string   "ip"
    t.string   "filter",          :default => "markdown"
    t.string   "source",          :default => "web"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
    t.integer  "messageboard_id"
  end

  add_index "thredded_posts", ["messageboard_id"], :name => "index_posts_on_messageboard_id"
  add_index "thredded_posts", ["topic_id"], :name => "index_posts_on_topic_id"
  add_index "thredded_posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "thredded_private_users", :force => true do |t|
    t.integer  "private_topic_id"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "thredded_roles", :force => true do |t|
    t.string   "level"
    t.integer  "user_id"
    t.integer  "messageboard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_seen"
  end

  add_index "thredded_roles", ["messageboard_id"], :name => "index_roles_on_messageboard_id"
  add_index "thredded_roles", ["user_id"], :name => "index_roles_on_user_id"

  create_table "thredded_topic_categories", :force => true do |t|
    t.integer "topic_id",    :null => false
    t.integer "category_id", :null => false
  end

  add_index "thredded_topic_categories", ["category_id"], :name => "index_topic_categories_on_category_id"
  add_index "thredded_topic_categories", ["topic_id"], :name => "index_topic_categories_on_topic_id"

  create_table "thredded_topics", :force => true do |t|
    t.integer  "user_id",                                 :null => false
    t.integer  "last_user_id",                            :null => false
    t.string   "title",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messageboard_id",                         :null => false
    t.string   "type"
    t.integer  "posts_count",     :default => 0
    t.string   "attribs",         :default => "[]"
    t.boolean  "sticky",          :default => false
    t.boolean  "locked",          :default => false
    t.string   "slug"
    t.string   "hash_id",                                 :null => false
    t.string   "state",           :default => "approved", :null => false
  end

  add_index "thredded_topics", ["hash_id"], :name => "index_topics_on_hash_id"
  add_index "thredded_topics", ["messageboard_id"], :name => "index_topics_on_messageboard_id"
  add_index "thredded_topics", ["slug"], :name => "index_topics_on_slug"
  add_index "thredded_topics", ["state"], :name => "index_topics_on_state"

  create_table "thredded_user_details", :force => true do |t|
    t.integer  "user_id",                               :null => false
    t.datetime "latest_activity_at"
    t.integer  "posts_count",        :default => 0
    t.integer  "topics_count",       :default => 0
    t.boolean  "superadmin",         :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "thredded_user_details", ["latest_activity_at"], :name => "index_thredded_user_details_on_latest_activity_at"
  add_index "thredded_user_details", ["user_id"], :name => "index_thredded_user_details_on_user_id"

  create_table "thredded_user_preferences", :force => true do |t|
    t.integer  "user_id",                                              :null => false
    t.string   "time_zone",  :default => "Eastern Time (US & Canada)"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "thredded_user_preferences", ["user_id"], :name => "index_thredded_user_preferences_on_user_id"

  create_table "thredded_user_topic_reads", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.integer  "topic_id",                   :null => false
    t.integer  "post_id",                    :null => false
    t.integer  "posts_count", :default => 0, :null => false
    t.integer  "page",        :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "thredded_user_topic_reads", ["page"], :name => "index_user_topic_reads_on_page"
  add_index "thredded_user_topic_reads", ["post_id"], :name => "index_user_topic_reads_on_post_id"
  add_index "thredded_user_topic_reads", ["posts_count"], :name => "index_user_topic_reads_on_posts_count"
  add_index "thredded_user_topic_reads", ["topic_id"], :name => "index_user_topic_reads_on_topic_id"
  add_index "thredded_user_topic_reads", ["user_id"], :name => "index_user_topic_reads_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",                           :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",                           :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "name"
    t.boolean  "superadmin",                            :default => false,                        :null => false
    t.integer  "posts_count",                           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topics_count",                          :default => 0
    t.string   "time_zone",                             :default => "Eastern Time (US & Canada)"
    t.string   "post_filter"
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
