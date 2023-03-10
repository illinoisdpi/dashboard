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

ActiveRecord::Schema[7.0].define(version: 2023_03_10_174420) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "cohorts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "year", null: false
    t.integer "generation", null: false
    t.integer "number", null: false
    t.string "piazza_course_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "role"
    t.uuid "user_id", null: false
    t.uuid "cohort_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_enrollments_on_cohort_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "piazza_activity_breakdowns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "enrollment_id", null: false
    t.string "emails", null: false
    t.string "role", null: false
    t.string "groups"
    t.integer "days_online", null: false
    t.integer "posts", null: false
    t.integer "edits_to_posts", null: false
    t.integer "answers", null: false
    t.integer "edits_to_answers", null: false
    t.integer "followups", null: false
    t.integer "replies_to_followups", null: false
    t.integer "instructor_good_question", null: false
    t.integer "instructor_good_answer", null: false
    t.integer "instructor_good_comment", null: false
    t.integer "student_good_question", null: false
    t.integer "student_thanks_on_answer", null: false
    t.integer "student_helpful_on_followups", null: false
    t.integer "good_question_given", null: false
    t.integer "thanks_on_answers_given", null: false
    t.integer "helpful_on_followups_given", null: false
    t.integer "post_views", null: false
    t.integer "live_qa_upvotes", null: false
    t.uuid "piazza_activity_download_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enrollment_id"], name: "index_piazza_activity_breakdowns_on_enrollment_id"
    t.index ["piazza_activity_download_id"], name: "index_piazza_activity_breakdowns_on_piazza_activity_download_id"
  end

  create_table "piazza_activity_downloads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "activity_from", null: false
    t.datetime "activity_until", null: false
    t.uuid "cohort_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_piazza_activity_downloads_on_cohort_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.citext "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "piazza_full"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enrollments", "cohorts"
  add_foreign_key "enrollments", "users"
  add_foreign_key "piazza_activity_breakdowns", "enrollments"
  add_foreign_key "piazza_activity_breakdowns", "piazza_activity_downloads"
  add_foreign_key "piazza_activity_downloads", "cohorts"
end
