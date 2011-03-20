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

  validates_presence_of     :podio_space_id
  validates_numericality_of :podio_space_id

  validates_presence_of :podio_user_password
  validates_format_of   :podio_user_email,   :as => :email_address

  validates_presence_of :zendesk_user_password
  validates_format_of   :zendesk_user_email, :as => :email_address

  def as_json
    {
      :id => self.id,

      :podio_space_id   => self.podio_space_id,
      :podio_user_email => self.podio_user_email,
  
      :zendesk_subdomain  => self.zendesk_subdomain,
      :zendesk_user_email => self.zendesk_user_email,
    }
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!
