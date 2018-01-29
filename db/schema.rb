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

ActiveRecord::Schema.define(version: 20180122204440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "hyperlink"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "semester_type"
    t.integer "semester_year", limit: 2
    t.string "short_title"
    t.boolean "allow_enrollment", default: false
  end


  create_table "instructions", force: :cascade do |t|
    t.boolean "initial_instructor"
    t.bigint "user_id"
    t.bigint "course_id"
    t.index ["course_id"], name: "index_instructions_on_course_id"
    t.index ["user_id", "course_id"], name: "index_instructions_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_instructions_on_user_id"
  end

  create_table "project_positions", force: :cascade do |t|
    t.integer "position"
    t.bigint "project_id"
    t.bigint "story_id"
    t.index ["project_id"], name: "index_project_positions_on_project_id"
    t.index ["story_id"], name: "index_project_positions_on_story_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_projects_on_course_id"
    t.index ["title", "course_id"], name: "index_projects_on_title_and_course_id", unique: true
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.index ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id"
    t.index ["user_id", "project_id"], name: "index_projects_users_on_user_id_and_project_id"
  end

  create_table "sprint_positions", force: :cascade do |t|
    t.integer "position"
    t.bigint "sprint_id"
    t.bigint "story_id"
    t.index ["sprint_id"], name: "index_sprint_positions_on_sprint_id"
    t.index ["story_id"], name: "index_sprint_positions_on_story_id"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_sprints_on_course_id"
  end

  create_table "sprints_topics", force: :cascade do |t|
    t.bigint "sprint_id"
    t.bigint "topic_id"
    t.index ["sprint_id", "topic_id"], name: "index_sprints_topics_on_sprint_id_and_topic_id", unique: true
    t.index ["sprint_id"], name: "index_sprints_topics_on_sprint_id"
    t.index ["topic_id"], name: "index_sprints_topics_on_topic_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "identifier"
    t.integer "status", default: 0
    t.integer "points"
    t.bigint "sprint_id"
    t.bigint "project_id"
    t.bigint "topic_id"
    t.index ["project_id"], name: "index_stories_on_project_id"
    t.index ["sprint_id"], name: "index_stories_on_sprint_id"
    t.index ["topic_id"], name: "index_stories_on_topic_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.bigint "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_tasks_on_story_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_topics_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "instructions", "courses", on_delete: :cascade
  add_foreign_key "instructions", "users"
  add_foreign_key "project_positions", "projects", on_delete: :cascade
  add_foreign_key "project_positions", "stories", on_delete: :cascade
  add_foreign_key "projects", "courses"
  add_foreign_key "sprint_positions", "sprints", on_delete: :cascade
  add_foreign_key "sprint_positions", "stories", on_delete: :cascade
  add_foreign_key "sprints", "courses"
  add_foreign_key "sprints_topics", "sprints"
  add_foreign_key "sprints_topics", "topics"
  add_foreign_key "stories", "projects"
  add_foreign_key "stories", "sprints"
  add_foreign_key "stories", "topics"
  add_foreign_key "tasks", "stories"
  add_foreign_key "topics", "courses"
end
