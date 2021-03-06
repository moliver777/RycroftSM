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

ActiveRecord::Schema.define(:version => 20160418144714) do

  create_table "bookings", :force => true do |t|
    t.integer  "event_id"
    t.integer  "client_id"
    t.integer  "horse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cost"
    t.boolean  "confirmed",  :default => false
    t.boolean  "rebooked",   :default => false
    t.boolean  "cancelled",  :default => false
  end

  create_table "clients", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "standard"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "post_code"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
    t.date     "last_reminder"
    t.string   "height"
    t.integer  "weight"
    t.boolean  "injury"
    t.text     "injury_details"
    t.text     "medical_notes"
    t.date     "tetanus_date"
    t.string   "doctor"
    t.string   "doctor_contact"
    t.string   "times_ridden"
    t.boolean  "walk"
    t.boolean  "trot_with"
    t.boolean  "trot_without"
    t.boolean  "canter"
    t.boolean  "hack"
    t.boolean  "jump_5_meter"
    t.boolean  "jump_75_meter"
    t.boolean  "x_country"
    t.string   "heard_about_us"
    t.integer  "leasing"
    t.string   "horses"
    t.string   "email_address"
    t.boolean  "hidden",                  :default => false, :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "event_type"
    t.text     "description"
    t.integer  "venue_id"
    t.date     "event_date"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "staff_id"
    t.integer  "master_venue_id"
    t.integer  "staff_id2"
    t.integer  "staff_id3"
    t.integer  "rebook_id"
    t.text     "staff_notes"
    t.boolean  "cancelled",       :default => false
  end

  create_table "horses", :force => true do |t|
    t.string   "name"
    t.string   "standard"
    t.integer  "max_day_workload"
    t.boolean  "availability"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "feed"
    t.string   "feed_extras"
    t.float    "hay_weight",              :default => 0.0
    t.text     "description"
    t.string   "height"
    t.string   "colour"
    t.integer  "max_weight"
    t.string   "owner"
    t.string   "owner_email"
    t.integer  "turnout_group",           :default => 0
    t.boolean  "walk"
    t.boolean  "trot_with"
    t.boolean  "trot_without"
    t.boolean  "canter"
    t.boolean  "hack"
    t.boolean  "jump_5_meter"
    t.boolean  "jump_75_meter"
    t.boolean  "x_country"
    t.boolean  "group",                   :default => true
    t.integer  "bhs",                     :default => 1
    t.boolean  "livery",                  :default => false
    t.boolean  "skip_issues",             :default => false
    t.boolean  "exercise"
    t.boolean  "farrier_enabled",         :default => false,  :null => false
    t.date     "farrier_date"
    t.integer  "farrier_repeat",          :default => 0,      :null => false
    t.boolean  "worming_enabled",         :default => false,  :null => false
    t.date     "worming_date"
    t.integer  "worming_repeat",          :default => 0,      :null => false
    t.boolean  "dentist_enabled",         :default => false,  :null => false
    t.date     "dentist_date"
    t.integer  "dentist_repeat",          :default => 0,      :null => false
    t.boolean  "physio_enabled",          :default => false,  :null => false
    t.date     "physio_date"
    t.integer  "physio_repeat",           :default => 0,      :null => false
    t.boolean  "vaccination_enabled",     :default => false,  :null => false
    t.date     "vaccination_date"
    t.integer  "vaccination_repeat",      :default => 0,      :null => false
    t.boolean  "other_enabled",           :default => false,  :null => false
    t.date     "other_date"
    t.integer  "other_repeat",            :default => 0,      :null => false
    t.string   "other_comments"
    t.string   "farrier_repeat_type",     :default => "week", :null => false
    t.string   "worming_repeat_type",     :default => "week", :null => false
    t.string   "dentist_repeat_type",     :default => "week", :null => false
    t.string   "physio_repeat_type",      :default => "week", :null => false
    t.string   "vaccination_repeat_type", :default => "week", :null => false
    t.string   "other_repeat_type",       :default => "week", :null => false
    t.boolean  "hidden",                  :default => false,  :null => false
  end

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "urgent"
    t.string   "category"
    t.integer  "booking_id"
    t.integer  "client_id"
    t.integer  "horse_id"
    t.integer  "staff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "hidden",     :default => false
    t.boolean  "weekly",     :default => false
    t.boolean  "repeated",   :default => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "booking_id"
    t.boolean  "cash",         :default => false
    t.boolean  "cc",           :default => false
    t.boolean  "cheque",       :default => false
    t.float    "amount",       :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "payment_date"
    t.boolean  "voucher",      :default => false
    t.string   "description"
    t.string   "reference"
    t.boolean  "hours",        :default => false
    t.boolean  "foc",          :default => false
    t.string   "stock_ids"
  end

  create_table "preferences", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "site_settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staffs", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "post_code"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
    t.boolean  "monday",         :default => false
    t.boolean  "tuesday",        :default => false
    t.boolean  "wednesday",      :default => false
    t.boolean  "thursday",       :default => false
    t.boolean  "friday",         :default => false
    t.boolean  "saturday",       :default => false
    t.boolean  "sunday",         :default => false
    t.boolean  "skip_issues",    :default => false
    t.boolean  "hidden",         :default => false, :null => false
  end

  create_table "stocks", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "cost",        :default => 0.0, :null => false
    t.integer  "quantity",    :default => 0,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "master",      :default => false
  end

end
