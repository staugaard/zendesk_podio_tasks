$LOAD_PATH << "#{File.dirname(__FILE__)}/lib"

require 'rubygems'
require 'bundler'
Bundler.require

require 'application'

run Sinatra::Application
