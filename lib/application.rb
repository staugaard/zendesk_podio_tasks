require 'sinatra'

configure :production do
  require 'newrelic_rpm'
end

get('/ping') do
  'OK'
end
