require_relative '../app'

require 'standalone_migrations/configurator'
require 'active_record'

require 'rspec_api_documentation'
require 'json_spec'
require 'json'

configurator = StandaloneMigrations::Configurator.new
ActiveRecord::Base.establish_connection configurator.config_for("test")

RspecApiDocumentation.configure do |config|
  config.app = Webmachine::Adapters::Rack.new(App.configuration, App.dispatcher)
end

RSpec.configure do |config|
  config.include JsonSpec::Helpers

  config.before do
  end
end
