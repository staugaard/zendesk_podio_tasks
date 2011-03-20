require 'sinatra'
require 'configuration'
require 'models'

configure :production do
  require 'newrelic_rpm'
end

get('/ping') do
  'OK'
end
