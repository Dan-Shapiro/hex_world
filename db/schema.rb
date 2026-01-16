# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_01_16_040558) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "hexes", force: :cascade do |t|
    t.integer "q", null: false
    t.integer "r", null: false
    t.string "spell_key", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["q", "r"], name: "index_hexes_on_q_and_r", unique: true
    t.index ["spell_key"], name: "index_hexes_on_spell_key", unique: true
  end

  create_table "run_hexes", force: :cascade do |t|
    t.bigint "run_id", null: false
    t.bigint "hex_id", null: false
    t.integer "unlocked_at_turn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hex_id"], name: "index_run_hexes_on_hex_id"
    t.index ["run_id", "hex_id"], name: "index_run_hexes_on_run_id_and_hex_id", unique: true
    t.index ["run_id"], name: "index_run_hexes_on_run_id"
    t.index ["unlocked_at_turn"], name: "index_run_hexes_on_unlocked_at_turn"
  end

  create_table "runs", force: :cascade do |t|
    t.jsonb "state", default: {}, null: false
    t.integer "turn", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.integer "seed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_runs_on_status"
  end

  add_foreign_key "run_hexes", "hexes"
  add_foreign_key "run_hexes", "runs"
end
