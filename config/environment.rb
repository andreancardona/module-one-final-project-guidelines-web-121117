require 'bundler'
Bundler.require
require 'rest-client'
require 'nokogiri'
require 'pry'
require 'rake'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
