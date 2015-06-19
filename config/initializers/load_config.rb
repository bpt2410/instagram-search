require File.dirname(__FILE__) + '/../environment.rb'
APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[ENV["RAILS_ENV"] ||= 'development']