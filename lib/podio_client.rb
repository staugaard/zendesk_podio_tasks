require 'podio'

Podio.configure do |config|
  config.api_key    = 'mick@zendesk.com'
  config.api_secret = '6Swzyh0uutKWjXNtNjcGcDjjjftuhE6c'
  config.debug      = true
end

class PodioClient
  attr_accessor :connection
  attr_accessor :space

  def initialize(space, email, password)
    podio = Podio::Client.new
    podio.get_access_token(email, password)

    self.space = space
    self.connection = podio.connection
  end

  def tasks
    connection.get("/task/?space=#{space}")
  end

  def update_task(task_id, comment)
    connection.put do |request|
      request.url "/task/#{task_id}/description"
      request.headers["Content-Type"] = "application/json"
      request.headers["Accept"]       = "application/json"
      request.body = {
        :description => { comment }
      }
    end
  end
end

