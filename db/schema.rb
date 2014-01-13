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

ActiveRecord::Schema.define(:version => 20140112203613) do

  create_table "assignment_groups", :force => true do |t|
    t.string   "name"
    t.integer  "weight"
    t.integer  "lop_mon_hoc_id"
    t.string   "state"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "position"
  end

  add_index "assignment_groups", ["lop_mon_hoc_id"], :name => "index_assignment_groups_on_lop_mon_hoc_id"

  create_table "assignments", :force => true do |t|
    t.integer  "assignment_group_id"
    t.integer  "lop_mon_hoc_id"
    t.integer  "points"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "position"
  end

  add_index "assignments", ["lop_mon_hoc_id", "assignment_group_id"], :name => "index_assignments_on_lop_mon_hoc_id_and_assignment_group_id"

  create_table "assistants", :force => true do |t|
    t.integer  "user_id"
    t.integer  "lop_mon_hoc_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "giang_vien_id"
  end

  add_index "assistants", ["lop_mon_hoc_id", "giang_vien_id"], :name => "index_assistants_on_lop_mon_hoc_id_and_giang_vien_id"
  add_index "assistants", ["user_id"], :name => "index_assistants_on_user_id"

  create_table "attendances", :force => true do |t|
    t.integer  "lich_trinh_giang_day_id"
    t.integer  "so_tiet_vang"
    t.boolean  "phep"
    t.string   "state"
    t.integer  "sinh_vien_id"
    t.text     "note"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "attendances", ["lich_trinh_giang_day_id", "sinh_vien_id"], :name => "index_attendances_on_lich_trinh_giang_day_id_and_sinh_vien_id"
  add_index "attendances", ["state"], :name => "index_attendances_on_state"

  create_table "calendars", :force => true do |t|
    t.integer  "so_tiet"
    t.integer  "so_tuan"
    t.integer  "thu"
    t.integer  "tiet_bat_dau"
    t.integer  "tuan_hoc_bat_dau"
    t.integer  "lop_mon_hoc_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "giang_vien_id"
    t.string   "state"
    t.string   "phong"
  end

  add_index "calendars", ["lop_mon_hoc_id", "giang_vien_id"], :name => "index_calendars_on_lop_mon_hoc_id_and_giang_vien_id"
  add_index "calendars", ["lop_mon_hoc_id"], :name => "index_calendars_on_lop_mon_hoc_id"

  create_table "du_gios", :force => true do |t|
    t.integer  "lich_trinh_giang_day_id"
    t.integer  "user_id"
    t.string   "state"
    t.text     "settings"
    t.text     "danh_gia"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "lop_mon_hoc_id"
    t.integer  "sinh_vien_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.decimal  "tinhhinh"
  end

  add_index "enrollments", ["lop_mon_hoc_id", "sinh_vien_id"], :name => "index_enrollments_on_lop_mon_hoc_id_and_sinh_vien_id"

  create_table "giang_viens", :force => true do |t|
    t.string   "ho"
    t.string   "dem"
    t.string   "ten"
    t.string   "code"
    t.string   "ten_khoa"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "giang_viens", ["code"], :name => "index_giang_viens_on_code"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lich_trinh_giang_days", :force => true do |t|
    t.datetime "thoi_gian"
    t.integer  "tuan"
    t.text     "noi_dung"
    t.integer  "so_tiet"
    t.string   "tiet_nghi"
    t.integer  "tiet_bat_dau"
    t.string   "phong"
    t.integer  "lop_mon_hoc_id"
    t.boolean  "thuc_hanh"
    t.string   "status"
    t.string   "state"
    t.integer  "moderator_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "giang_vien_id"
    t.integer  "so_tiet_moi"
    t.text     "note"
    t.datetime "completed_at"
    t.integer  "user_id"
    t.string   "ltype"
  end

  add_index "lich_trinh_giang_days", ["giang_vien_id", "lop_mon_hoc_id"], :name => "index_lich_trinh_giang_days_on_giang_vien_id_and_lop_mon_hoc_id"
  add_index "lich_trinh_giang_days", ["lop_mon_hoc_id", "giang_vien_id"], :name => "index_lich_trinh_giang_days_on_lop_mon_hoc_id_and_giang_vien_id"

  create_table "lop_mon_hocs", :force => true do |t|
    t.string   "ma_lop"
    t.string   "ma_mon_hoc"
    t.text     "settings"
    t.string   "state"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "giang_vien_id"
    t.string   "ten_mon_hoc"
  end

  add_index "lop_mon_hocs", ["giang_vien_id"], :name => "index_lop_mon_hocs_on_giang_vien_id"

  create_table "questions", :force => true do |t|
    t.integer  "survey_id"
    t.string   "name"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "results", :force => true do |t|
    t.integer  "question_id"
    t.text     "data"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sinh_viens", :force => true do |t|
    t.string   "ho"
    t.string   "dem"
    t.string   "ten"
    t.datetime "ngay_sinh"
    t.string   "code"
    t.string   "ma_lop_hanh_chinh"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.boolean  "tin_chi"
    t.string   "khoa"
    t.string   "he"
    t.string   "nganh"
    t.integer  "gioi_tinh"
    t.integer  "position"
  end

  create_table "submissions", :force => true do |t|
    t.integer  "assignment_id"
    t.decimal  "grade"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "enrollment_id"
  end

  create_table "surveys", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tenants", :force => true do |t|
    t.string   "hoc_ky"
    t.string   "nam_hoc"
    t.datetime "ngay_bat_dau"
    t.datetime "ngay_ket_thuc"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tuans", :force => true do |t|
    t.integer  "stt"
    t.date     "tu_ngay"
    t.date     "den_ngay"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.integer  "imageable_id"
    t.string   "imageable_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
