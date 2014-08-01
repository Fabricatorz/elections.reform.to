require 'webmachine'
require 'webmachine/adapters/rack'
require 'active_record'
require 'json'

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

class CandidateResource < JsonResource
  def allowed_methods
    ["GET"]
  end

  def cycle
    request.path_info[:cycle].to_i
  end

  def id
    # Remove any .json extension from the token
    request.path_info[:id].sub(/\.json$/,'')
  end

  def href
    @request.base_uri.to_s + + "finances/#{cycle}/candidates/#{id}"
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    @item = ActiveRecord::Base.connection.select_one("SELECT * FROM candidates WHERE can_id = #{ActiveRecord::Base.sanitize(id)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)}")

    if @item.nil?
      @response.headers['Content-Type'] = 'application/json'
      @response.body = '{"status":"ERROR","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","errors":["Record not found"]}'
    end

    !@item.nil?
  end

  def to_json
    CandidateSerializer.new(base_uri, cycle, @item).to_json
  end
end

class SeatsResource < JsonResource
  def allowed_methods
    ["GET"]
  end

  def cycle
    request.path_info[:cycle].to_i
  end

  def state_token
    # Remove any .json extension from the token
    request.path_info[:state].sub(/\.json$/,'')
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    @collection = ActiveRecord::Base.connection.select_all("SELECT * FROM candidates WHERE can_off_sta = #{ActiveRecord::Base.sanitize(state_token)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} ORDER BY can_off_sta ASC, can_off_dis ASC, can_nam ASC")

    unless @collection.any?
      @response.headers['Content-Type'] = 'application/json'
      @response.body = '{"status":"ERROR","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","errors":["Record not found"]}'
    end

    @collection.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state_token, nil, @collection).to_json
  end
end

class OfficeSeatsResource < JsonResource
  def allowed_methods
    ["GET"]
  end

  def cycle
    request.path_info[:cycle].to_i
  end

  def state_token
    request.path_info[:state]
  end

  def office_token
    # Remove any .json extension from the token
    request.path_info[:office].sub(/\.json$/,'')
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    case office_token
    when 'house'
      can_off = 'H'
    when 'senate'
      can_off = 'S'
    end

    @collection = ActiveRecord::Base.connection.select_all("SELECT * FROM candidates WHERE can_off_sta = #{ActiveRecord::Base.sanitize(state_token)} AND can_off = #{ActiveRecord::Base.sanitize(can_off)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} ORDER BY can_off_sta ASC, can_off_dis ASC, can_nam ASC")

    unless @collection.any?
      @response.headers['Content-Type'] = 'application/json'
      @response.body = '{"status":"ERROR","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","errors":["Record not found"]}'
    end

    @collection.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state_token, nil, @collection).to_json
  end
end

class DistrictSeatsResource < JsonResource
  def allowed_methods
    ["GET"]
  end

  def cycle
    request.path_info[:cycle].to_i
  end

  def state_token
    request.path_info[:state]
  end

  def office_token
    request.path_info[:office]
  end

  def district_token
    # Remove any .json extension from the token
    request.path_info[:district].sub(/\.json$/,'')
  end

  def base_uri
    @request.base_uri.to_s + "finances/#{cycle}/"
  end

  def resource_exists?
    @collection = ActiveRecord::Base.connection.select_all("SELECT * FROM candidates WHERE can_off_sta = #{ActiveRecord::Base.sanitize(state_token)} AND can_off = 'H' AND can_off_dis = #{ActiveRecord::Base.sanitize(district_token)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} AND election_yr = #{ActiveRecord::Base.sanitize(cycle)} ORDER BY can_off_sta ASC, can_off_dis ASC, can_nam ASC")

    unless @collection.any?
      @response.headers['Content-Type'] = 'application/json'
      @response.body = '{"status":"ERROR","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","errors":["Record not found"]}'
    end

    @collection.any?
  end

  def to_json
    CandidatesSerializer.new(base_uri, cycle, state_token, district_token, @collection).to_json
  end
end

App = Webmachine::Application.new do |app|
  app.configure do |config|
    config.adapter = :Rack
  end
  app.routes do
    add ["finances", :cycle, "candidates", :id], CandidateResource
    add ["finances", :cycle, "seats", :state], SeatsResource
    add ["finances", :cycle, "seats", :state, :office], OfficeSeatsResource
    add ["finances", :cycle, "seats", :state, "house", :district], DistrictSeatsResource
    #add ['trace', '*'], Webmachine::Trace::TraceResource
  end
end
