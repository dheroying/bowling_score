# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_16_144340) do

  create_table "games", force: :cascade do |t|
    t.integer "players"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shots", force: :cascade do |t|
    t.integer "game_id"
    t.integer "number", default: 0
    t.integer "frame", default: 0
    t.integer "player", default: 0
    t.integer "pins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_shots_on_game_id"
  end

  add_foreign_key "shots", "games"
end
