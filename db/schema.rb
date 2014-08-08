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

ActiveRecord::Schema.define(:version => 20140807101832) do

  create_table "candidates", :force => true do |t|
    t.integer "election_yr",           :limit => 2
    t.text    "lin_ima"
    t.string  "can_id",                :limit => 9
    t.string  "can_nam",               :limit => 90
    t.string  "can_off",               :limit => 1
    t.string  "can_off_sta",           :limit => 2
    t.string  "can_off_dis",           :limit => 2
    t.string  "can_par_aff",           :limit => 3
    t.string  "can_inc_cha_ope_sea"
    t.text    "can_str1"
    t.text    "can_str2"
    t.text    "can_cit"
    t.string  "can_sta",               :limit => 2
    t.string  "can_zip",               :limit => 9
    t.decimal "ind_ite_con",                         :precision => 15, :scale => 2
    t.decimal "ind_uni_con",                         :precision => 15, :scale => 2
    t.decimal "ind_con",                             :precision => 15, :scale => 2
    t.decimal "par_com_con",                         :precision => 15, :scale => 2
    t.decimal "oth_com_con",                         :precision => 15, :scale => 2
    t.decimal "can_con",                             :precision => 15, :scale => 2
    t.decimal "tot_con",                             :precision => 15, :scale => 2
    t.decimal "tra_fro_oth_aut_com",                 :precision => 15, :scale => 2
    t.decimal "can_loa",                             :precision => 15, :scale => 2
    t.decimal "oth_loa",                             :precision => 15, :scale => 2
    t.decimal "tot_loa",                             :precision => 15, :scale => 2
    t.decimal "off_to_ope_exp",                      :precision => 15, :scale => 2
    t.decimal "off_to_fun",                          :precision => 15, :scale => 2
    t.decimal "off_to_leg_acc",                      :precision => 15, :scale => 2
    t.decimal "oth_rec",                             :precision => 15, :scale => 2
    t.decimal "tot_rec",                             :precision => 15, :scale => 2
    t.decimal "ope_exp",                             :precision => 15, :scale => 2
    t.decimal "exe_leg_acc_dis",                     :precision => 15, :scale => 2
    t.decimal "fun_dis",                             :precision => 15, :scale => 2
    t.decimal "tra_to_oth_aut_com",                  :precision => 15, :scale => 2
    t.decimal "can_loa_rep",                         :precision => 15, :scale => 2
    t.decimal "oth_loa_rep",                         :precision => 15, :scale => 2
    t.decimal "tot_loa_rep",                         :precision => 15, :scale => 2
    t.decimal "ind_ref",                             :precision => 15, :scale => 2
    t.decimal "par_com_ref",                         :precision => 15, :scale => 2
    t.decimal "oth_com_ref",                         :precision => 15, :scale => 2
    t.decimal "tot_con_ref",                         :precision => 15, :scale => 2
    t.decimal "oth_dis",                             :precision => 15, :scale => 2
    t.decimal "tot_dis",                             :precision => 15, :scale => 2
    t.decimal "cas_on_han_beg_of_per",               :precision => 15, :scale => 2
    t.decimal "cas_on_han_clo_of_per",               :precision => 15, :scale => 2
    t.decimal "net_con",                             :precision => 15, :scale => 2
    t.decimal "net_ope_exp",                         :precision => 15, :scale => 2
    t.decimal "deb_owe_by_com",                      :precision => 15, :scale => 2
    t.decimal "deb_owe_to_com",                      :precision => 15, :scale => 2
    t.date    "cov_sta_dat"
    t.date    "cov_end_dat"
  end

  add_index "candidates", ["can_id"], :name => "index_candidates_on_can_id"
  add_index "candidates", ["can_nam"], :name => "index_candidates_on_can_nam"
  add_index "candidates", ["can_off_sta"], :name => "index_candidates_on_can_off_sta"
  add_index "candidates", ["election_yr", "can_id"], :name => "index_candidates_on_election_yr_and_can_id", :unique => true
  add_index "candidates", ["election_yr"], :name => "index_candidates_on_election_yr"

  create_table "races", :force => true do |t|
    t.integer "election_yr", :limit => 2
    t.string  "can_id",      :limit => 9
    t.boolean "on_ballot"
  end

  add_index "races", ["can_id"], :name => "index_races_on_can_id"
  add_index "races", ["election_yr", "can_id"], :name => "index_races_on_election_yr_and_can_id", :unique => true
  add_index "races", ["election_yr"], :name => "index_races_on_election_yr"

end
