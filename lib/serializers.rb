class CandidateSerializer

  def initialize(base_uri, cycle, candidate)
    @base_uri = base_uri
    @cycle = cycle
    @candidate = candidate
  end

  def to_json
    to_hash.to_json
  end

  def status
    "OK"
  end

  def copyright
    "Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved."
  end

  def to_hash
    can_id = @candidate['can_id']
    state = @candidate['can_off_sta']
    district = @candidate['can_off_dis']
    office = @candidate['can_off']

    {
      :status => status,
      :copyright => copyright,
      :base_uri => @base_uri,
      :cycle => @cycle,
      :results => [
        {
          :id => can_id,
          :name => @candidate['can_nam'],
          :party => @candidate['can_par_aff'],
          :district => district_link(state, office, district),
          :fec_uri => fec_uri(can_id),
          :committee => nil,
          :state => state_link(state)
        }
      ]
    }
  end

  private
  def state_link(state)
    "/seats/#{state}.json"
  end

  def district_link(state, office, district)
    case office
    when 'H'
      "/seats/#{state}/house/#{district}.json"
    when 'S'
      "/seats/#{state}/senate.json"
    end
  end

  def fec_uri(can_id)
    "http://docquery.fec.gov/cgi-bin/fecimg/?#{can_id}"
  end
end

class CandidatesSerializer < CandidateSerializer

  def initialize(base_uri, cycle, state, district, candidates)
    @base_uri = base_uri
    @cycle = cycle
    @state = state
    @district = district
    @candidates = candidates
  end

  def to_json
    to_hash.to_json
  end

  def to_hash
    results = @candidates.map do |item|
      can_id = item['can_id']
      state = item['can_off_sta']
      district = item['can_off_dis']
      office = item['can_off']
      {
        :candidate => {
          :id => item['can_id'],
          :relative_uri => "/candidates/#{can_id}.json",
          :name => item['can_nam'],
          :party => item['can_par_aff']
        },
        :district => district_link(state, office, district),
        :state => state_link(state)
      }
    end
    {
      :status => status,
      :copyright => copyright,
      :base_uri => @base_uri,
      :cycle => @cycle,
      :state => @state,
      :district => @district,
      :num_results => results.length,
      :results => results
    }
  end
end
