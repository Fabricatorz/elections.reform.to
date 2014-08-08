require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Finances" do

  before (:each) do

    # NH-1
    ActiveRecord::Base.connection.insert("INSERT INTO candidates (election_yr, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea) VALUES (2014, 'H6NH01230', 'SHEA-PORTER, CAROL', 'H', 'NH', '01', 'DEM', 'INCUMBENT')")
    ActiveRecord::Base.connection.insert("INSERT INTO candidates (election_yr, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea) VALUES (2014, 'H0NH01217', 'GUINTA, FRANK', 'H', 'NH', '01','REP','CHALLENGER')");

    # NH-2
    ActiveRecord::Base.connection.insert("INSERT INTO candidates (election_yr, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea) VALUES (2014, 'H0NH02181', 'KUSTER, ANN MCLANE', 'H', 'NH', '02','DEM','INCUMBENT')");
    ActiveRecord::Base.connection.insert("INSERT INTO candidates (election_yr, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea) VALUES (2014, 'H4NH02233', 'LAMBERT, GARY', 'H', 'NH', '02','REP','CHALLENGER')");

    # NH-Senate
    ActiveRecord::Base.connection.insert("INSERT INTO candidates (election_yr, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea) VALUES (2014, 'S4NH00112', 'RUBENS, JIM', 'S', 'NH', '00', 'REP', 'CHALLENGER')")
    ActiveRecord::Base.connection.insert("INSERT INTO candidates (election_yr, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea) VALUES (2014, 'S0NH00219', 'SHAHEEN, JEANNE', 'S','NH', '00','DEM','INCUMBENT')");
    ActiveRecord::Base.connection.insert("INSERT INTO candidates (election_yr, can_id, can_nam, can_off, can_off_sta, can_off_dis, can_par_aff, can_inc_cha_ope_sea) VALUES (2014, 'S4NH00120', 'BROWN, SCOTT', 'S','NH', '00','REP','CHALLENGER')");
  end

  after (:each) do
    ActiveRecord::Base.connection.delete("DELETE FROM candidates");
  end

  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/finances/:cycle/candidates/:id" do
    let(:cycle) { "2014" }
    let(:id) { "H6NH01230" }

    example "Getting a single house candidate" do
      do_request

      expect(response_body).to be_json_eql({
        :status => "OK",
        :copyright => "Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.",
        :base_uri => "http://example.org/finances/2014/",
        :cycle => 2014,
        :results => [
          {
            :id => "H6NH01230",
            :name => "SHEA-PORTER, CAROL",
            :party => "DEM",
            :district => "/seats/NH/house/01.json",
            :fec_uri => "http://docquery.fec.gov/cgi-bin/fecimg/?H6NH01230",
            :committee => nil,
            :state => "/seats/NH.json"
          }
        ]
      }.to_json)

      expect(response_body).to be_json_eql(JSON.parse('{"status":"OK","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","base_uri":"http://example.org/finances/2014/","cycle":2014,"results":[{"id":"H6NH01230","name":"SHEA-PORTER, CAROL","party":"DEM","district":"/seats/NH/house/01.json","fec_uri":"http://docquery.fec.gov/cgi-bin/fecimg/?H6NH01230","committee":null,"state":"/seats/NH.json"}]}').to_json)

      expect(status).to eq(200)
    end
  end

  get "/finances/:cycle/candidates/:id" do
    let(:cycle) { "2014" }
    let(:id) { "S4NH00112" }

    example "Getting a single senate candidate" do
      do_request

      expect(response_body).to be_json_eql(JSON.parse('{"status":"OK","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","base_uri":"http://example.org/finances/2014/","cycle":2014,"results":[{"id":"S4NH00112","name":"RUBENS, JIM","party":"REP","district":"/seats/NH/senate.json","fec_uri":"http://docquery.fec.gov/cgi-bin/fecimg/?S4NH00112","committee":null,"state":"/seats/NH.json"}]}').to_json)

      expect(status).to eq(200)
    end
  end

  get "/finances/:cycle/candidates/:id" do
    let(:cycle) { "2014" }
    let(:id) { "H6NH01230.json" }

    example "Getting a single candidate with .json extension" do
      do_request

      expect(status).to eq(200)
    end
  end

  get "/finances/:cycle/candidates/:id" do
    let(:cycle) { "2014" }
    let(:id) { "XXX" }

    example "Getting a candidate that doesn't exist" do
      do_request

      expect(response_body).to have_json_path("status")
      expect(response_body).to have_json_path("errors")

      expect(status).to eq(404)
    end
  end

  get "/finances/:cycle/seats/:state" do
    let(:cycle) { "2014" }
    let(:state) { "NH" }

    example "Getting all seats in a state" do
      do_request

      expect(response_body).to be_json_eql(JSON.parse('{"status":"OK","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","base_uri":"http://example.org/finances/2014/","cycle":2014,"state":"NH","district":null,"num_results":7,"results":[{"candidate":{"id":"S4NH00120","relative_uri":"/candidates/S4NH00120.json","name":"BROWN, SCOTT","party":"REP"},"district":"/seats/NH/senate.json","state":"/seats/NH.json"},{"candidate":{"id":"S4NH00112","relative_uri":"/candidates/S4NH00112.json","name":"RUBENS, JIM","party":"REP"},"district":"/seats/NH/senate.json","state":"/seats/NH.json"},{"candidate":{"id":"S0NH00219","relative_uri":"/candidates/S0NH00219.json","name":"SHAHEEN, JEANNE","party":"DEM"},"district":"/seats/NH/senate.json","state":"/seats/NH.json"},{"candidate":{"id":"H0NH01217","relative_uri":"/candidates/H0NH01217.json","name":"GUINTA, FRANK","party":"REP"},"district":"/seats/NH/house/01.json","state":"/seats/NH.json"},{"candidate":{"id":"H6NH01230","relative_uri":"/candidates/H6NH01230.json","name":"SHEA-PORTER, CAROL","party":"DEM"},"district":"/seats/NH/house/01.json","state":"/seats/NH.json"},{"candidate":{"id":"H0NH02181","relative_uri":"/candidates/H0NH02181.json","name":"KUSTER, ANN MCLANE","party":"DEM"},"district":"/seats/NH/house/02.json","state":"/seats/NH.json"},{"candidate":{"id":"H4NH02233","relative_uri":"/candidates/H4NH02233.json","name":"LAMBERT, GARY","party":"REP"},"district":"/seats/NH/house/02.json","state":"/seats/NH.json"}]}').to_json)

    end
  end

  get "/finances/:cycle/seats/:state" do
    let(:cycle) { "2014" }
    let(:state) { "NH.json" }

    example "Getting a state with .json extension" do
      do_request

      expect(status).to eq(200)
    end
  end

  get "/finances/:cycle/seats/:state" do
    let(:cycle) { "2014" }
    let(:id) { "XX" }

    example "Getting a state that doesn't exist" do
      do_request

      expect(response_body).to have_json_path("status")
      expect(response_body).to have_json_path("errors")

      expect(status).to eq(404)
    end
  end

  get "/finances/:cycle/seats/:state/:office" do
    let(:cycle) { "2014" }
    let(:state) { "NH" }
    let(:office) { "house.json" }

    example "Getting an office with .json extension" do
      do_request

      expect(status).to eq(200)
    end
  end

  get "/finances/:cycle/seats/:state/:office" do
    let(:cycle) { "2014" }
    let(:state) { "NH" }
    let(:office) { "house" }

    example "Getting all house seats in a state" do
      do_request

      expect(response_body).to be_json_eql(JSON.parse('{"status":"OK","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","base_uri":"http://example.org/finances/2014/","cycle":2014,"state":"NH","district":null,"num_results":4,"results":[{"candidate":{"id":"H0NH01217","relative_uri":"/candidates/H0NH01217.json","name":"GUINTA, FRANK","party":"REP"},"district":"/seats/NH/house/01.json","state":"/seats/NH.json"},{"candidate":{"id":"H6NH01230","relative_uri":"/candidates/H6NH01230.json","name":"SHEA-PORTER, CAROL","party":"DEM"},"district":"/seats/NH/house/01.json","state":"/seats/NH.json"},{"candidate":{"id":"H0NH02181","relative_uri":"/candidates/H0NH02181.json","name":"KUSTER, ANN MCLANE","party":"DEM"},"district":"/seats/NH/house/02.json","state":"/seats/NH.json"},{"candidate":{"id":"H4NH02233","relative_uri":"/candidates/H4NH02233.json","name":"LAMBERT, GARY","party":"REP"},"district":"/seats/NH/house/02.json","state":"/seats/NH.json"}]}').to_json)
    end
  end

  get "/finances/:cycle/seats/:state/:office" do
    let(:cycle) { "2014" }
    let(:state) { "NH" }
    let(:office) { "senate" }

    example "Getting all senate seats in a state" do
      do_request

      expect(response_body).to be_json_eql(JSON.parse('{"status":"OK","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","base_uri":"http://example.org/finances/2014/","cycle":2014,"state":"NH","district":null,"num_results":3,"results":[{"candidate":{"id":"S4NH00120","relative_uri":"/candidates/S4NH00120.json","name":"BROWN, SCOTT","party":"REP"},"district":"/seats/NH/senate.json","state":"/seats/NH.json"},{"candidate":{"id":"S4NH00112","relative_uri":"/candidates/S4NH00112.json","name":"RUBENS, JIM","party":"REP"},"district":"/seats/NH/senate.json","state":"/seats/NH.json"},{"candidate":{"id":"S0NH00219","relative_uri":"/candidates/S0NH00219.json","name":"SHAHEEN, JEANNE","party":"DEM"},"district":"/seats/NH/senate.json","state":"/seats/NH.json"}]}').to_json)
    end
  end

  get "/finances/:cycle/seats/:state/house/:district" do
    let(:cycle) { "2014" }
    let(:state) { "NH" }
    let(:district) { "01" }

    example "Getting all house seats in a district" do
      do_request

      expect(response_body).to be_json_eql(JSON.parse('{"status":"OK","copyright":"Copyright (c) 2014 Fabricatorz, LLC. All Rights Reserved.","base_uri":"http://example.org/finances/2014/","cycle":2014,"state":"NH","district":"01","num_results":2,"results":[{"candidate":{"id":"H0NH01217","relative_uri":"/candidates/H0NH01217.json","name":"GUINTA, FRANK","party":"REP"},"district":"/seats/NH/house/01.json","state":"/seats/NH.json"},{"candidate":{"id":"H6NH01230","relative_uri":"/candidates/H6NH01230.json","name":"SHEA-PORTER, CAROL","party":"DEM"},"district":"/seats/NH/house/01.json","state":"/seats/NH.json"}]}').to_json)
    end
  end

  get "/finances/:cycle/seats/:state/house/:district" do
    let(:cycle) { "2014" }
    let(:state) { "NH" }
    let(:district) { "01.json" }

    example "Getting a district with .json extension" do
      do_request

      expect(status).to eq(200)
    end
  end
end
