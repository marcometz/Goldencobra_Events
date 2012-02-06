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

ActiveRecord::Schema.define(:version => 20120206113043) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "goldencobra_articles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "url_name"
    t.string   "slug"
    t.text     "content"
    t.text     "teaser"
    t.string   "ancestry"
    t.boolean  "startpage",       :default => false
    t.boolean  "active",          :default => true
    t.string   "subtitle"
    t.text     "summary"
    t.text     "context_info"
    t.string   "canonical_url"
    t.boolean  "robots_no_index", :default => false
    t.integer  "event_id"
    t.integer  "event_levels",    :default => 0
  end

  add_index "goldencobra_articles", ["ancestry"], :name => "index_goldencobra_articles_on_ancestry"
  add_index "goldencobra_articles", ["slug"], :name => "index_goldencobra_articles_on_slug"

  create_table "goldencobra_events_event_pricegroups", :force => true do |t|
    t.integer  "event_id"
    t.integer  "pricegroup_id"
    t.float    "price",                       :default => 0.0
    t.integer  "max_number_of_participators", :default => 0
    t.datetime "cancelation_until"
    t.datetime "start_reservation"
    t.datetime "end_reservation"
    t.boolean  "available",                   :default => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "webcode"
  end

  create_table "goldencobra_events_events", :force => true do |t|
    t.string   "ancestry"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "active",                      :default => true
    t.string   "external_link"
    t.integer  "max_number_of_participators", :default => 0
    t.string   "type_of_event"
    t.string   "type_of_registration"
    t.boolean  "exclusive",                   :default => false
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "panel_id"
  end

  create_table "goldencobra_events_panels", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "link_url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "goldencobra_events_pricegroups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "goldencobra_events_venues", :force => true do |t|
    t.integer  "location_id"
    t.string   "title"
    t.text     "description"
    t.string   "link_url"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "goldencobra_locations", :force => true do |t|
    t.string   "lat"
    t.string   "lng"
    t.string   "street"
    t.string   "city"
    t.string   "zip"
    t.string   "region"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "goldencobra_menues", :force => true do |t|
    t.string   "title"
    t.string   "target"
    t.string   "css_class"
    t.boolean  "active",     :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "ancestry"
  end

  add_index "goldencobra_menues", ["ancestry"], :name => "index_goldencobra_menues_on_ancestry"

  create_table "goldencobra_metatags", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "article_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "goldencobra_roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "goldencobra_roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "goldencobra_uploads", :force => true do |t|
    t.string   "source"
    t.string   "rights"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
