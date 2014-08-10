require 'open-uri'
require 'nokogiri'
require 'yaml'

def import_races(uri, db, year)
  doc = YAML.load(open(uri))

  election_yr = year
  delete_races = db.prepare("DELETE FROM races where election_yr = ?")
  delete_races.execute(election_yr)

  insert_races = db.prepare "INSERT INTO races (election_yr, can_id, on_ballot) VALUES (?, ?, ?)"

  doc.each do |can|
    can_id = can['id']['fec'][0]

    case can['races'][0]['on_ballot']
    when 'Y', 'y', 'true', true
      on_ballot = 1
    when 'N', 'n', 'false', false
      on_ballot = 0
    else
      on_ballot = nil
    end

    unless on_ballot.nil?
      insert_races.execute election_yr, can_id, on_ballot
    end
  end
end

def import_candidate_summary(uri, db, year)
  begin
    doc = Nokogiri::XML(open(uri))
  rescue
    puts "Received invalid XML"
    exit 1
  end

  delete_candidates = db.prepare("DELETE FROM candidates where election_yr = ?")
  delete_candidates.execute(year)

  election_yr = year;
  insert_candidate = db.prepare "INSERT INTO candidates (election_yr, lin_ima, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea, can_str1, can_str2, can_cit, can_sta, can_zip, ind_ite_con, ind_uni_con, ind_con, par_com_con, oth_com_con, can_con, tot_con, tra_fro_oth_aut_com, can_loa, oth_loa, tot_loa, off_to_ope_exp, off_to_fun, off_to_leg_acc, oth_rec, tot_rec, ope_exp, exe_leg_acc_dis, fun_dis, tra_to_oth_aut_com, can_loa_rep, oth_loa_rep, tot_loa_rep, ind_ref, par_com_ref, oth_com_ref, tot_con_ref, oth_dis, tot_dis, cas_on_han_beg_of_per, cas_on_han_clo_of_per, net_con, net_ope_exp, deb_owe_by_com, deb_owe_to_com, cov_sta_dat, cov_end_dat) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

  doc.xpath("//can_sum").each do |can|
    lin_ima = can.xpath('lin_ima').text
    can_id = can.xpath('can_id').text
    can_nam = can.xpath('can_nam').text
    can_off = can.xpath('can_off').text
    can_off_sta = can.xpath('can_off_sta').text
    can_off_dis = can.xpath('can_off_dis').text
    can_par_aff = can.xpath('can_par_aff').text
    can_inc_cha_ope_sea = can.xpath('can_inc_cha_ope_sea').text
    can_str1 = can.xpath('can_str1').text
    can_str2 = can.xpath('can_str2').text
    can_cit = can.xpath('can_cit').text
    can_sta = can.xpath('can_sta').text
    can_zip = can.xpath('can_zip').text
    ind_ite_con = cur_to_dec(can.xpath('ind_ite_con').text)
    ind_uni_con = cur_to_dec(can.xpath('ind_uni_con').text)
    ind_con = cur_to_dec(can.xpath('ind_con').text)
    par_com_con = cur_to_dec(can.xpath('par_com_con').text)
    oth_com_con = cur_to_dec(can.xpath('oth_com_con').text)
    can_con = cur_to_dec(can.xpath('can_con').text)
    tot_con = cur_to_dec(can.xpath('tot_con').text)
    tra_fro_oth_aut_com = cur_to_dec(can.xpath('tra_fro_oth_aut_com').text)
    can_loa = cur_to_dec(can.xpath('can_loa').text)
    oth_loa = cur_to_dec(can.xpath('oth_loa').text)
    tot_loa = cur_to_dec(can.xpath('tot_loa').text)
    off_to_ope_exp = cur_to_dec(can.xpath('off_to_ope_exp').text)
    off_to_fun = cur_to_dec(can.xpath('off_to_fun').text)
    off_to_leg_acc = cur_to_dec(can.xpath('off_to_leg_acc').text)
    oth_rec = cur_to_dec(can.xpath('oth_rec').text)
    tot_rec = cur_to_dec(can.xpath('tot_rec').text)
    ope_exp = cur_to_dec(can.xpath('ope_exp').text)
    exe_leg_acc_dis = cur_to_dec(can.xpath('exe_leg_acc_dis').text)
    fun_dis = cur_to_dec(can.xpath('fun_dis').text)
    tra_to_oth_aut_com = cur_to_dec(can.xpath('tra_to_oth_aut_com').text)
    can_loa_rep = cur_to_dec(can.xpath('can_loa_rep').text)
    oth_loa_rep = cur_to_dec(can.xpath('oth_loa_rep').text)
    tot_loa_rep = cur_to_dec(can.xpath('tot_loa_rep').text)
    ind_ref = cur_to_dec(can.xpath('ind_ref').text)
    par_com_ref = cur_to_dec(can.xpath('par_com_ref').text)
    oth_com_ref = cur_to_dec(can.xpath('oth_com_ref').text)
    tot_con_ref = cur_to_dec(can.xpath('tot_con_ref').text)
    oth_dis = cur_to_dec(can.xpath('oth_dis').text)
    tot_dis = cur_to_dec(can.xpath('tot_dis').text)
    cas_on_han_beg_of_per = cur_to_dec(can.xpath('cas_on_han_beg_of_per').text)
    cas_on_han_clo_of_per = cur_to_dec(can.xpath('cas_on_han_clo_of_per').text)
    net_con = cur_to_dec(can.xpath('net_con').text)
    net_ope_exp = cur_to_dec(can.xpath('net_ope_exp').text)
    deb_owe_by_com = cur_to_dec(can.xpath('deb_owe_by_com').text)
    deb_owe_to_com = cur_to_dec(can.xpath('deb_owe_to_com').text)
    cov_sta_dat = can.xpath('cov_sta_dat').text
    cov_end_dat = can.xpath('cov_end_dat').text

    insert_candidate.execute election_yr, lin_ima, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea, can_str1, can_str2, can_cit, can_sta, can_zip, ind_ite_con, ind_uni_con, ind_con, par_com_con, oth_com_con, can_con, tot_con, tra_fro_oth_aut_com, can_loa, oth_loa, tot_loa, off_to_ope_exp, off_to_fun, off_to_leg_acc, oth_rec, tot_rec, ope_exp, exe_leg_acc_dis, fun_dis, tra_to_oth_aut_com, can_loa_rep, oth_loa_rep, tot_loa_rep, ind_ref, par_com_ref, oth_com_ref, tot_con_ref, oth_dis, tot_dis, cas_on_han_beg_of_per, cas_on_han_clo_of_per, net_con, net_ope_exp, deb_owe_by_com, deb_owe_to_com, cov_sta_dat, cov_end_dat
  end

end

# convert currency in the form "$1,234.56" to "1234.56"
# <xs:pattern value="(^-?\$(\d{1,3}(\,\d{3})*|(\d+))?(\.\d{1,2})?$)?" />
def cur_to_dec(amount)
    return (amount || "$0.00").gsub(/[^\d\.]/, '')
end

unless ENV["election_yr"].nil?
  db = ActiveRecord::Base.connection.raw_connection

  year = ENV["election_yr"]
  candidate_uri = "http://www.fec.gov/data/CandidateSummary.do?format=xml&election_yr=#{year}"

  task = ENV["task"] ? ENV["task"] : "all"

  if (task === "candidates" or task === "all")
    import_candidate_summary(candidate_uri, db, year)
  end

  races_uri = "https://raw.githubusercontent.com/Reform-to/congress-candidates/master/candidates-current.yaml"

  if (task === "races" or task === "all")
    import_races(races_uri, db, year)
  end

  db.close
else
  puts "Please specify an election year: rake db:seed election_yr=2014"
end
