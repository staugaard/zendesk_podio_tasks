require 'sinatra'
require 'configuration'
require 'models'

configure :production do
  require 'newrelic_rpm'
end

get('/ping') do
  'OK'
end

get('/links.json') do
  content_type :json
  SpaceLinking.all.map(&:as_json).to_json
end

get('/links/:id.json') do
  content_type :json
  SpaceLinking.find(params[:id]).as_json.to_json
end

post('/links.json') do
  content_type :json

  document = JSON.parse(request.body.read)
  new_link = SpaceLinking.new(
    :podio_space_id      => document[:podio_space_id],
    :podio_user_email    => document[:podio_space_id],
    :podio_user_password => document[:podio_space_id],

    :zendesk_subdomain     => document[:podio_space_id],
    :zendesk_user_email    => document[:podio_space_id],
    :zendesk_user_password => document[:podio_space_id]
  )
  if new_link.save
    "{status: 'OK'}"
  else
    new_link.errors.to_json
  end
end
