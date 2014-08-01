require 'active_record'

class CandidatesRecords

  def self.by_id(cycle, id)
      ActiveRecord::Base.connection.select_one("SELECT * FROM candidates WHERE can_id = #{ActiveRecord::Base.sanitize(id)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)}")
  end

  def self.by_state(cycle, state)
    ActiveRecord::Base.connection.select_all("SELECT * FROM candidates WHERE can_off_sta = #{ActiveRecord::Base.sanitize(state)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} ORDER BY can_off_sta ASC, can_off_dis ASC, can_nam ASC")
  end

  def self.by_office(cycle, state, office)
    @collection = ActiveRecord::Base.connection.select_all("SELECT * FROM candidates WHERE can_off_sta = #{ActiveRecord::Base.sanitize(state)} AND can_off = #{ActiveRecord::Base.sanitize(office)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} ORDER BY can_off_sta ASC, can_off_dis ASC, can_nam ASC")
  end

  def self.by_district(cycle, state, district, office = 'H')
    ActiveRecord::Base.connection.select_all("SELECT * FROM candidates WHERE can_off_sta = #{ActiveRecord::Base.sanitize(state)} AND can_off = #{ActiveRecord::Base.sanitize(office)} AND can_off_dis = #{ActiveRecord::Base.sanitize(district)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} ORDER BY can_off_sta ASC, can_off_dis ASC, can_nam ASC")
  end
end

