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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160418144714) do

  create_table "bookings", force: :cascade do |t|
    t.integer  "event_id",   limit: 4
    t.integer  "client_id",  limit: 4
    t.integer  "horse_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "cost",       limit: 24
    t.boolean  "confirmed",             default: false
    t.boolean  "rebooked",              default: false
    t.boolean  "cancelled",             default: false
  end

  create_table "clients", force: :cascade do |t|
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "standard",                limit: 255
    t.string   "address_line_1",          limit: 255
    t.string   "address_line_2",          limit: 255
    t.string   "city",                    limit: 255
    t.string   "county",                  limit: 255
    t.string   "country",                 limit: 255
    t.string   "post_code",               limit: 255
    t.string   "home_phone",              limit: 255
    t.string   "mobile_phone",            limit: 255
    t.string   "emergency_contact_name",  limit: 255
    t.string   "emergency_contact_phone", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
    t.date     "last_reminder"
    t.string   "height",                  limit: 255
    t.integer  "weight",                  limit: 4
    t.boolean  "injury"
    t.text     "injury_details",          limit: 65535
    t.text     "medical_notes",           limit: 65535
    t.date     "tetanus_date"
    t.string   "doctor",                  limit: 255
    t.string   "doctor_contact",          limit: 255
    t.string   "times_ridden",            limit: 255
    t.boolean  "walk"
    t.boolean  "trot_with"
    t.boolean  "trot_without"
    t.boolean  "canter"
    t.boolean  "hack"
    t.boolean  "jump_5_meter"
    t.boolean  "jump_75_meter"
    t.boolean  "x_country"
    t.string   "heard_about_us",          limit: 255
    t.integer  "leasing",                 limit: 4
    t.string   "horses",                  limit: 255
    t.string   "email_address",           limit: 255
    t.boolean  "hidden",                                default: false, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "event_type",      limit: 255
    t.text     "description",     limit: 65535
    t.integer  "venue_id",        limit: 4
    t.date     "event_date"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "staff_id",        limit: 4
    t.integer  "master_venue_id", limit: 4
    t.integer  "staff_id2",       limit: 4
    t.integer  "staff_id3",       limit: 4
    t.integer  "rebook_id",       limit: 4
    t.text     "staff_notes",     limit: 65535
    t.boolean  "cancelled",                     default: false
  end

  create_table "horses", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.string   "standard",                limit: 255
    t.integer  "max_day_workload",        limit: 4
    t.boolean  "availability"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "feed",                    limit: 255
    t.string   "feed_extras",             limit: 255
    t.float    "hay_weight",              limit: 24,    default: 0.0
    t.text     "description",             limit: 65535
    t.string   "height",                  limit: 255
    t.string   "colour",                  limit: 255
    t.integer  "max_weight",              limit: 4
    t.string   "owner",                   limit: 255
    t.string   "owner_email",             limit: 255
    t.integer  "turnout_group",           limit: 4,     default: 0
    t.boolean  "walk"
    t.boolean  "trot_with"
    t.boolean  "trot_without"
    t.boolean  "canter"
    t.boolean  "hack"
    t.boolean  "jump_5_meter"
    t.boolean  "jump_75_meter"
    t.boolean  "x_country"
    t.boolean  "group",                                 default: true
    t.integer  "bhs",                     limit: 4,     default: 1
    t.boolean  "livery",                                default: false
    t.boolean  "skip_issues",                           default: false
    t.boolean  "exercise"
    t.boolean  "farrier_enabled",                       default: false,  null: false
    t.date     "farrier_date"
    t.integer  "farrier_repeat",          limit: 4,     default: 0,      null: false
    t.boolean  "worming_enabled",                       default: false,  null: false
    t.date     "worming_date"
    t.integer  "worming_repeat",          limit: 4,     default: 0,      null: false
    t.boolean  "dentist_enabled",                       default: false,  null: false
    t.date     "dentist_date"
    t.integer  "dentist_repeat",          limit: 4,     default: 0,      null: false
    t.boolean  "physio_enabled",                        default: false,  null: false
    t.date     "physio_date"
    t.integer  "physio_repeat",           limit: 4,     default: 0,      null: false
    t.boolean  "vaccination_enabled",                   default: false,  null: false
    t.date     "vaccination_date"
    t.integer  "vaccination_repeat",      limit: 4,     default: 0,      null: false
    t.boolean  "other_enabled",                         default: false,  null: false
    t.date     "other_date"
    t.integer  "other_repeat",            limit: 4,     default: 0,      null: false
    t.string   "other_comments",          limit: 255
    t.string   "farrier_repeat_type",     limit: 255,   default: "week", null: false
    t.string   "worming_repeat_type",     limit: 255,   default: "week", null: false
    t.string   "dentist_repeat_type",     limit: 255,   default: "week", null: false
    t.string   "physio_repeat_type",      limit: 255,   default: "week", null: false
    t.string   "vaccination_repeat_type", limit: 255,   default: "week", null: false
    t.string   "other_repeat_type",       limit: 255,   default: "week", null: false
    t.boolean  "hidden",                                default: false,  null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.boolean  "urgent"
    t.string   "category",   limit: 255
    t.integer  "booking_id", limit: 4
    t.integer  "client_id",  limit: 4
    t.integer  "horse_id",   limit: 4
    t.integer  "staff_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "hidden",                   default: false
    t.boolean  "weekly",                   default: false
    t.boolean  "repeated",                 default: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "booking_id",   limit: 4
    t.boolean  "cash",                     default: false
    t.boolean  "cc",                       default: false
    t.boolean  "cheque",                   default: false
    t.float    "amount",       limit: 24,  default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "payment_date"
    t.boolean  "voucher",                  default: false
    t.string   "description",  limit: 255
    t.string   "reference",    limit: 255
    t.boolean  "hours",                    default: false
    t.boolean  "foc",                      default: false
    t.string   "stock_ids",    limit: 255
  end

  create_table "preferences", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "site_settings", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staffs", force: :cascade do |t|
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.string   "role",           limit: 255
    t.string   "address_line_1", limit: 255
    t.string   "address_line_2", limit: 255
    t.string   "city",           limit: 255
    t.string   "county",         limit: 255
    t.string   "country",        limit: 255
    t.string   "post_code",      limit: 255
    t.string   "home_phone",     limit: 255
    t.string   "mobile_phone",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
    t.boolean  "monday",                     default: false
    t.boolean  "tuesday",                    default: false
    t.boolean  "wednesday",                  default: false
    t.boolean  "thursday",                   default: false
    t.boolean  "friday",                     default: false
    t.boolean  "saturday",                   default: false
    t.boolean  "sunday",                     default: false
    t.boolean  "skip_issues",                default: false
    t.boolean  "hidden",                     default: false, null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.float    "cost",        limit: 24,  default: 0.0, null: false
    t.integer  "quantity",    limit: 4,   default: 0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 255
    t.string   "password",   limit: 255
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "user_level", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "master",                    default: false
  end

end
