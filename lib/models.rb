require 'dm-core'
require 'dm-validations'

class TaskTicketMapping
  include DataMapper::Resource

  property :id, Serial
  property :podio_task_id, Integer
  property :zendesk_ticket_id, Integer
  property :updated_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!
