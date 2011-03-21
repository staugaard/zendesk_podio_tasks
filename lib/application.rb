require 'sinatra'
require 'configuration'
require 'models'
require 'podio_client'
require 'zendesk_client'

configure :production do
  require 'newrelic_rpm'
end

get('/ping') do
  SpaceLinking.all.each do |link|
    podio = PodioClient.new(link.podio_user_email, link.podio_user_password, link.podio_space_id)
    podio.tasks.each do |podio_task|
      unless TaskTicketMapping.first(:podio_task_id => podio_task['task_id'])
        zendesk = ZendeskClient.new(link.zendesk_subdomain, link.zendesk_user_email, link.zendesk_user_password, false)
        ticket_id = zendesk.create(link.podio_user_email, podio_task['due_date'], "You have this task waiting in Podio")
        TaskTicketMapping.create(:podio_task_id => podio_task['task_id'], :zendesk_ticket_id => ticket_id, :updated_at => Time.now)
      end
    end
  end

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
    :podio_space_id      => document['podio_space_id'],
    :podio_user_email    => document['podio_user_email'],
    :podio_user_password => document['podio_user_password'],

    :zendesk_subdomain     => document['zendesk_subdomain'],
    :zendesk_user_email    => document['zendesk_user_email'],
    :zendesk_user_password => document['zendesk_user_password']
  )
  if new_link.save
    "{status: 'OK'}"
  else
    new_link.errors.to_json
  end
end
