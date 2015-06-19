require File.dirname(__FILE__) + '/../environment.rb'
ENV["RAILS_ENV"] ||= 'development'
APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")