require 'bundler'
Bundler.require
require 'rest-client'
<<<<<<< HEAD
require 'json'
require 'nokogiri'
=======
require 'nokogiri'
require 'pry'
>>>>>>> 52ab0ff6c57348449e4348b1e69a00484270b74f

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
