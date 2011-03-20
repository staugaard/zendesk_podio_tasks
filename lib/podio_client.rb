require 'podio'

Podio.configure do |config|
  config.api_key    = 'mick@zendesk.com'
  config.api_secret = '6Swzyh0uutKWjXNtNjcGcDjjjftuhE6c'
  config.debug      = false
end

class PodioClient
  attr_accessor :connection

  def initialize(space, email, password)
    podio = Podio::Client.new
    podio.get_access_token(email, password)

    self.connection = podio.connection
  end

  def tasks
    connection.get("/tasks?space=#{1}")
  end
end

