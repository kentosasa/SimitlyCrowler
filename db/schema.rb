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

ActiveRecord::Schema.define(version: 20151116123327) do

  create_table "entries", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "entries", ["title"], name: "index_entries_on_title", using: :btree

  create_table "entry_contents", force: :cascade do |t|
    t.text     "content",      limit: 65535
    t.text     "content_html", limit: 65535
    t.text     "url",          limit: 65535
    t.text     "thumbnail",    limit: 65535
    t.text     "description",  limit: 65535
    t.integer  "entry_id",     limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "entry_contents", ["entry_id"], name: "index_entry_contents_on_entry_id", using: :btree

  create_table "entry_meta", force: :cascade do |t|
    t.integer  "count",      limit: 4
    t.string   "category",   limit: 255
    t.integer  "entry_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "entry_word_relations", force: :cascade do |t|
    t.integer  "entry_id",   limit: 4
    t.integer  "word_id",    limit: 4
    t.integer  "position",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "entry_word_relations", ["entry_id"], name: "index_entry_word_relations_on_entry_id", using: :btree
  add_index "entry_word_relations", ["word_id"], name: "index_entry_word_relations_on_word_id", using: :btree

  create_table "keywords", force: :cascade do |t|
    t.integer  "entry_id",   limit: 4
    t.integer  "word_id",    limit: 4
    t.float    "score",      limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "keywords", ["entry_id", "word_id"], name: "index_keywords_on_entry_id_and_word_id", using: :btree
  add_index "keywords", ["word_id"], name: "index_keywords_on_word_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "surface_form", limit: 255
    t.string   "pos",          limit: 255
    t.string   "basic_form",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "idf",          limit: 24
  end

  add_index "words", ["basic_form"], name: "index_words_on_basic_form", using: :btree
  add_index "words", ["pos"], name: "index_words_on_pos", using: :btree
  add_index "words", ["surface_form"], name: "index_words_on_surface_form", using: :btree

end
