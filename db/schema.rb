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

ActiveRecord::Schema.define(:version => 20130112231236) do

  create_table "games", :force => true do |t|
    t.integer  "p_1_id"
    t.integer  "p_2_id"
    t.integer  "p_3_id"
    t.integer  "p_4_id"
    t.integer  "p_5_id"
    t.integer  "p_6_id"
    t.integer  "p_7_id"
    t.integer  "p_8_id"
    t.integer  "p_9_id"
    t.integer  "p_10_id"
    t.boolean  "radiant_victory"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "p_1_accept"
    t.boolean  "p_2_accept"
    t.boolean  "p_3_accept"
    t.boolean  "p_4_accept"
    t.boolean  "p_5_accept"
    t.boolean  "p_6_accept"
    t.boolean  "p_7_accept"
    t.boolean  "p_8_accept"
    t.boolean  "p_9_accept"
    t.boolean  "p_10_accept"
    t.string   "state",           :default => "accepting"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",                :null => false
    t.string   "encrypted_password",     :default => "",                :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.float    "mu",                     :default => 25.0
    t.float    "sigma",                  :default => 8.333333333333334
    t.boolean  "is_admin",               :default => false
    t.boolean  "is_mod",                 :default => false
    t.string   "username"
    t.boolean  "is_queued",              :default => false
    t.string   "authentication_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
