require_relative 'app'
require 'standalone_migrations/configurator'
require 'active_record'

configurator = StandaloneMigrations::Configurator.new
ActiveRecord::Base.establish_connection configurator.config_for("development")

App.run
