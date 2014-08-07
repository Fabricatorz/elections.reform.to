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

  def cycle
    request.path_info[:cycle].to_i
  end

  def error_body
    '{"status":"ERROR","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","errors":["Record not found"]}'
  end

end

class StatesResource < ElectionsResource

  def state
    # Remove any .json extension from the token
    request.path_info[:state].sub(/\.json$/,'')
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
    request.path_info[:office].sub(/\.json$/,'')
  end

end

class DistrictsResource < OfficesResource

  def district
    request.path_info[:district].sub(/\.json$/,'')
  end

end

class CandidateResource < ElectionsResource
  def allowed_methods
    ["GET"]
  end

  def id
    request.path_info[:id].sub(/\.json$/,'')
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    @resource = CandidatesRecords.by_id(cycle, id)

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
  def allowed_methods
    ["GET"]
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    @resources = CandidatesRecords.by_state(cycle, state)

    @resources.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state, nil, @resources).to_json
  end
end

class OfficeResource < OfficesResource
  def allowed_methods
    ["GET"]
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    case office
    when 'house'
      can_off = 'H'
    when 'senate'
      can_off = 'S'
    end

    @resources = CandidatesRecords.by_office(cycle, state, can_off)

    @resources.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state, nil, @resources).to_json
  end
end

class DistrictResource < DistrictsResource
  def allowed_methods
    ["GET"]
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    @resources = CandidatesRecords.by_district(cycle, state, district)

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
    add ["finances", :cycle, "candidates", :id], CandidateResource
    add ["finances", :cycle, "seats", :state], StateResource
    add ["finances", :cycle, "seats", :state, :office], OfficeResource
    add ["finances", :cycle, "seats", :state, "house", :district], DistrictResource
    #add ['trace', '*'], Webmachine::Trace::TraceResource
  end
end
