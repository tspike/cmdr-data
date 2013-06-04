#!/usr/bin/env ruby

require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => "postgresql",  :host => "localhost", :database => "weather")
#, :username => "youruser", :password => "yourpassword"  )
 
#take the version from the command line, or use nil if there is no command line argument
ActiveRecord::Migrator.migrate "./migrations", nil
