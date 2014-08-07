require 'active_record'

class CandidatesRecords

  def self.by_id(cycle, id)
    s_cycle = ActiveRecord::Base.sanitize(cycle)
    s_id = ActiveRecord::Base.sanitize(id)

    selection = "can_id = #{s_id} AND election_yr = #{s_cycle}"

    relation = "SELECT #{projection} FROM #{relations} WHERE #{selection}"
    ActiveRecord::Base.connection.select_one(relation)
  end

  def self.by_state(cycle, state)
    s_state = ActiveRecord::Base.sanitize(state)
    s_cycle = ActiveRecord::Base.sanitize(cycle)

    selection = "can_off_sta = #{s_state} AND election_yr = #{s_cycle}"

    relation = "SELECT #{projection} FROM #{relations} WHERE #{selection} ORDER BY #{order}"
    ActiveRecord::Base.connection.select_all(relation)
  end

  def self.by_office(cycle, state, office)
    s_office = ActiveRecord::Base.sanitize(office)
    s_state = ActiveRecord::Base.sanitize(state)
    s_cycle = ActiveRecord::Base.sanitize(cycle)

    selection = "can_off = #{s_office} AND can_off_sta = #{s_state} AND election_yr = #{s_cycle}"

    relation = "SELECT #{projection} FROM #{relations} WHERE #{selection} ORDER BY #{order}"
    ActiveRecord::Base.connection.select_all(relation)
  end

  def self.by_district(cycle, state, district, office = 'H')
    s_office = ActiveRecord::Base.sanitize(office)
    s_district = ActiveRecord::Base.sanitize(district)
    s_state = ActiveRecord::Base.sanitize(state)
    s_cycle = ActiveRecord::Base.sanitize(cycle)

    selection = "can_off = #{s_office} AND can_off_sta = #{s_state} AND can_off_dis = #{s_district} AND election_yr = #{s_cycle}"

    relation = "SELECT #{projection} FROM #{relations} WHERE #{selection} ORDER BY #{order}"
    ActiveRecord::Base.connection.select_all(relation)
  end

  protected
  def self.projection
    "can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff"
  end

  def self.relations
    "candidates"
  end

  def self.order
    "can_off_sta ASC, can_off_dis ASC, can_nam ASC"
  end
end

