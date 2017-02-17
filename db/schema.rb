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

ActiveRecord::Schema.define(version: 20170217093253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "title"
    t.boolean  "archived",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["creator_id"], name: "index_boards_on_creator_id", using: :btree
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "list_id"
    t.integer  "creator_id"
    t.integer  "assignee_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "archived",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["assignee_id"], name: "index_cards_on_assignee_id", using: :btree
    t.index ["creator_id"], name: "index_cards_on_creator_id", using: :btree
    t.index ["list_id"], name: "index_cards_on_list_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "creator_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_comments_on_card_id", using: :btree
    t.index ["creator_id"], name: "index_comments_on_creator_id", using: :btree
  end

  create_table "lists", force: :cascade do |t|
    t.integer  "board_id"
    t.integer  "creator_id"
    t.string   "title"
    t.boolean  "archived",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["board_id"], name: "index_lists_on_board_id", using: :btree
    t.index ["creator_id"], name: "index_lists_on_creator_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "boards", "users", column: "creator_id"
  add_foreign_key "cards", "lists"
  add_foreign_key "cards", "users", column: "assignee_id"
  add_foreign_key "cards", "users", column: "creator_id"
  add_foreign_key "comments", "cards"
  add_foreign_key "comments", "users", column: "creator_id"
  add_foreign_key "lists", "boards"
  add_foreign_key "lists", "users", column: "creator_id"
end
