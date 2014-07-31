# Reform.to Elections API

Elections data for Reform.to.

## Requirements

* Ruby 1.9.3+
* Bundler
* MySQL, SQLite3

## Installation

Clone this repository and then run:

    bundle install

## Set-up

Create your database, and then add a configuration file to `db/config.yml`, e.g.:

    development:
      adapter: mysql
      encoding: utf8
      reconnect: false
      database: DATABASE_NAME
      pool: 5
      username: DATABASE_USER
      password: DATABASE_PASS
      socket: /var/run/mysqld/mysqld.sock
    test:
      adapter: sqlite3
      encoding: utf8
      database: db/test.sqlite3

Set up the database:

    rake db:migrate

Seed the database with FEC election data. This command will download a candidate summary file from FEC.gov and insert it into the database. It will take a while  to run:

    rake db:seed election_yr=2014

## Usage

To run locally:

    bundle exec ruby boot.rb

To run with Unicorn:

    bundle exec unicorn -Eproduction -p8080 config.ru

To run with Phusion Passenger, first install it, then create an Apache VirtualHost file for the site:

    <VirtualHost *:80>
        ServerName elections.reform.to
        DocumentRoot /var/www/elections.reform.to/public
        Header set Access-Control-Allow-Origin "*"
        <Directory /var/www/elections.reform.to/public>
            Allow from all
            Options -MultiViews
            # Uncomment this if you're on Apache >= 2.4:
            Require all granted
        </Directory>
    </VirtualHost>

Enable the site and then re-start Apache. To restart the site, run the command:

    touch tmp/restart.txt

## Testing

Run the command:

    rake db:migrate RAILS_ENV=test
    bundle exec rspec
