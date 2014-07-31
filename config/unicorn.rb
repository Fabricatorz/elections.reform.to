preload_app true

before_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |server, worker|
  # other settings
  if defined?(ActiveRecord::Base)
    #config = ActiveRecord::Base.configurations[Rails.env] ||
    #            Rails.application.config.database_configuration[Rails.env]

    configurator = StandaloneMigrations::Configurator.new
    config = configurator.config_for("development")

    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']            =   ENV['DB_POOL'] || 2
    ActiveRecord::Base.establish_connection(config)
  end
end
