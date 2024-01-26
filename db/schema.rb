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

ActiveRecord::Schema[7.0].define(version: 2024_01_18_083011) do
  create_table "materials", charset: "utf8", force: :cascade do |t|
    t.string "material_type", null: false
    t.string "category", null: false
    t.integer "thickness", null: false
    t.integer "width"
    t.string "option"
    t.integer "length", null: false
    t.float "stock", null: false
    t.integer "material_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_destination"
    t.index ["user_id"], name: "index_materials_on_user_id"
  end

  create_table "need_materials", charset: "utf8", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.integer "material_id", null: false
    t.float "length", null: false
    t.float "length_option"
    t.integer "necessary_nums", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_need_materials_on_part_id"
    t.index ["user_id"], name: "index_need_materials_on_user_id"
  end

  create_table "parts", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "stock", null: false
    t.boolean "finished", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_destination"
    t.index ["user_id"], name: "index_parts_on_user_id"
  end

  create_table "parts_relations", charset: "utf8", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "child_id"
    t.integer "necessary_nums", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_parts_relations_on_child_id"
    t.index ["parent_id"], name: "index_parts_relations_on_parent_id"
    t.index ["user_id"], name: "index_parts_relations_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "registered_material_nums", default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_code", null: false
    t.integer "prefecture_id", null: false
    t.string "city", null: false
    t.string "house_number", null: false
    t.string "building"
    t.string "phone_number", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "materials", "users"
  add_foreign_key "need_materials", "parts"
  add_foreign_key "need_materials", "users"
  add_foreign_key "parts", "users"
  add_foreign_key "parts_relations", "users"
end
