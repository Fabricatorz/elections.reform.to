require 'webmachine/adapter'
require 'webmachine/adapters/rack'
require 'standalone_migrations/configurator'
require 'active_record'
require File.join(File.dirname(__FILE__), 'app')

configurator = StandaloneMigrations::Configurator.new
ActiveRecord::Base.establish_connection configurator.config_for("development")

run App.adapter
