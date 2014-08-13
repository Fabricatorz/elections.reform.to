require 'webmachine'
require 'webmachine/adapters/rack'
require 'json'

require_relative 'lib/records'
require_relative 'lib/serializers'

class JsonResource < Webmachine::Resource
  def content_types_provided
    [["application/json", :to_json]]
  end

  def content_types_accepted
    [["application/json", :from_json]]
  end

  private
  def params
    JSON.parse(request.body.to_s)
  end
end

class ElectionsResource < JsonResource
  def allowed_methods
    ["GET"]
  end

  def base_resource
    request.disp_path[0, request.disp_path.index('/')]
  end

  def base_uri
    @request.base_uri.to_s + "#{base_resource}/#{cycle}/"
  end

  def cycle
    request.path_info[:cycle].to_i
  end

  def error_body
    '{"status":"ERROR","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","errors":["Record not found"]}'
  end

end

class StatesResource < ElectionsResource

  def state
    s = request.path_info[:state].sub(/\.json$/,'')
    s.gsub(/\W+/, '')
  end

  def finish_request
    if defined? @resources
      unless @resources.any?
        response.headers['Content-Type'] = 'application/json'
        response.body = error_body
      end
    end
    nil
  end

end

class OfficesResource < StatesResource

  def office
    o = request.path_info[:office].sub(/\.json$/,'')
    o.slice(/^(house|senate)$/)
  end

end

class DistrictsResource < OfficesResource

  def district
    d = request.path_info[:district].sub(/\.json$/,'')
    "%02d" % d.gsub(/[^0-9]/, '').to_i
  end

end

class SearchResource < ElectionsResource

  def query
    if request.query['query']
      request.query['query']
    end
  end

  def resource_exists?
    if query
      @resources = FinancesRecords.search(cycle, query)
    else
      @resources = []
    end
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, nil, nil, @resources).to_json
  end

  def finish_request
    if defined? @resources
      unless @resources.any?
        response.headers['Content-Type'] = 'application/json'
        response.body = error_body
      end
    end
    nil
  end

end

class CandidateResource < ElectionsResource
  def id
    i = request.path_info[:id].sub(/\.json$/,'')
    i.gsub(/[^A-Z0-9]+/, '')
  end

  def resource_exists?
    @resource = FinancesRecords.by_id(cycle, id)

    !@resource.nil?
  end

  def to_json
    CandidateSerializer.new(base_uri, cycle, @resource).to_json
  end

  def finish_request
    if @resource.nil?
      response.headers['Content-Type'] = 'application/json'
      response.body = error_body
    end
  end

end

class StateResource < StatesResource
  def resource_exists?
    case base_resource
    when 'finances'
      @resources = FinancesRecords.by_state(cycle, state)
    when 'races'
      @resources = RacesRecords.by_state(cycle, state)
    end

    @resources.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state, nil, @resources).to_json
  end
end

class OfficeResource < OfficesResource
  def resource_exists?
    case base_resource
    when 'finances'
      @resources = FinancesRecords.by_office(cycle, state, can_off)
    when 'races'
      @resources = RacesRecords.by_office(cycle, state, can_off)
    end

    @resources.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state, nil, @resources).to_json
  end

  protected
  def can_off
    case office
    when 'house'
      'H'
    when 'senate'
      'S'
    end
  end

end

class DistrictResource < DistrictsResource
  def resource_exists?
    case base_resource
    when 'finances'
      @resources = FinancesRecords.by_district(cycle, state, district)
    when 'races'
      @resources = RacesRecords.by_district(cycle, state, district)
    end

    @resources.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state, district, @resources).to_json
  end
end

App = Webmachine::Application.new do |app|
  app.configure do |config|
    config.adapter = :Rack
  end
  app.routes do
    add ["finances", :cycle, "candidates", "search"], SearchResource
    add ["finances", :cycle, "candidates", "search.json"], SearchResource
    add ["finances", :cycle, "candidates", :id], CandidateResource
    add ["finances", :cycle, "seats", :state], StateResource
    add ["finances", :cycle, "seats", :state, :office], OfficeResource
    add ["finances", :cycle, "seats", :state, "house", :district], DistrictResource

    add ["races", :cycle, "candidates", "search"], SearchResource
    add ["races", :cycle, "candidates", "search.json"], SearchResource
    add ["races", :cycle, "candidates", :id], CandidateResource
    add ["races", :cycle, "seats", :state], StateResource
    add ["races", :cycle, "seats", :state, :office], OfficeResource
    add ["races", :cycle, "seats", :state, "house", :district], DistrictResource

    #add ['trace', '*'], Webmachine::Trace::TraceResource
  end
end
