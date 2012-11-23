# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100513210347) do

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "playable_id"
    t.string   "playable_type"
    t.integer  "first_participant_id"
    t.integer  "second_participant_id"
    t.string   "participant_type"
    t.string   "state"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "best_of"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "ranking_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "branch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
  end

  create_table "ranking_lines", :force => true do |t|
    t.integer  "group_id"
    t.integer  "participant_id"
    t.string   "participant_type"
    t.integer  "points"
    t.integer  "win"
    t.integer  "draw"
    t.integer  "lose"
    t.integer  "plus"
    t.integer  "minus"
    t.integer  "diff"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "round"
    t.integer  "win_points"
    t.integer  "draw_points"
    t.integer  "lose_points"
    t.integer  "groups_number"
    t.integer  "qualified"
    t.integer  "games_number"
    t.string   "state"
    t.integer  "best_of"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "game_id"
    t.integer  "game_round"
    t.integer  "first_score"
    t.integer  "second_score"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "tag"
    t.string   "website"
    t.string   "email"
    t.string   "irc"
    t.string   "motto"
    t.string   "nationality"
    t.string   "password_hash"
    t.string   "password_salt"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.integer  "event_id"
    t.integer  "branch_id"
    t.string   "name"
    t.integer  "max_participants"
    t.string   "participants_type"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tree_positions", :force => true do |t|
    t.integer  "tree_id"
    t.integer  "participant_id"
    t.string   "participant_type"
    t.integer  "position"
    t.boolean  "special"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trees", :force => true do |t|
    t.integer  "tournament_id"
    t.string   "tree_type"
    t.string   "state"
    t.integer  "best_of"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_cookies", :force => true do |t|
    t.integer  "user_id"
    t.string   "cookie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.string   "password_hash"
    t.string   "address"
    t.string   "zip_code",      :limit => 10
    t.date     "birthdate"
    t.string   "country"
    t.string   "email"
    t.string   "phone",         :limit => 20
    t.string   "sex",           :limit => 1
    t.boolean  "admin",                       :default => false
    t.string   "city"
    t.string   "password_salt", :limit => 20
    t.string   "cookie_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
