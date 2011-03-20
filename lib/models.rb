require 'dm-core'
require 'dm-validations'

class TaskTicketMapping
  include DataMapper::Resource

  property :id, Serial
  property :podio_task_id, Integer
  property :zendesk_ticket_id, Integer
  property :updated_at, DateTime
end

class SpaceLinking
  include DataMapper::Resource

  property :id, Serial

  property :podio_space_id, Integer
  property :podio_user_email, String
  property :podio_user_password, String
  
  property :zendesk_subdomain, String
  property :zendesk_user_email, String
  property :zendesk_user_password, String
end

DataMapper.finalize
DataMapper.auto_upgrade!
