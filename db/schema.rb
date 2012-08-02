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

ActiveRecord::Schema.define(:version => 20120802182053) do

  create_table "bookings", :force => true do |t|
    t.integer  "event_id"
    t.integer  "client_id"
    t.integer  "horse_id"
    t.boolean  "has_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "event_type"
    t.string   "standard"
    t.integer  "venue_id"
    t.date     "event_date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "max_clients"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "staff_id"
  end

  create_table "horses", :force => true do |t|
    t.string   "name"
    t.string   "standard"
    t.integer  "max_day_workload"
    t.boolean  "availability"
    t.boolean  "farrier"
    t.date     "farrier_date"
    t.integer  "farrier_freq"
    t.boolean  "worming"
    t.date     "worming_date"
    t.string   "worming_freq"
    t.boolean  "vet"
    t.date     "vet_date"
    t.string   "vet_freq"
    t.boolean  "medication"
    t.date     "medication_date"
    t.string   "medication_freq"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "preferences", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.string   "external"
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
  end

end
