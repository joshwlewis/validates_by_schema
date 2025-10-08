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

ActiveRecord::Schema.define(version: 20_121_210_034_140) do
  create_table 'widgets', force: true do |t|
    t.string 'name',          limit: 50
    t.string 'model',                                                null: false
    t.text 'description'
    t.integer 'wheels',                                              null: false
    t.integer 'doors',         limit: 2
    t.decimal 'price',                       precision: 6, scale: 2
    t.decimal 'cost',                        precision: 4, scale: 2, null: false
    t.decimal 'completion'
    t.float 'rating'
    t.float 'score',                                                 null: false
    t.datetime 'published_at'
    t.date 'invented_on'
    t.time 'startup_time'
    t.time 'shutdown_time',                                          null: false
    t.boolean 'enabled'
    t.binary 'data'
    t.integer 'parent_id',                                           null: false
    t.integer 'legacy_id',                                           null: false
    t.integer 'other_id'
    t.integer 'kind',                                                null: false
    t.string 'list', ENV['DB'] == 'postgresql' ? { array: true, limit: 3 } : {}

    t.index 'parent_id'
    t.index ['name', 'wheels'], unique: true
    t.index 'other_id', unique: true
    t.index 'legacy_id', unique: true
    t.index ['doors'], unique: true, where: 'enabled = true'
    t.index ['model', 'price'], unique: true
    t.index ['model', 'cost'], unique: true
  end
end
