require 'podio'

Podio.configure do |config|
  config.api_key    = 'mick@zendesk.com'
  config.api_secret = '6Swzyh0uutKWjXNtNjcGcDjjjftuhE6c'
  config.debug      = true
end

class PodioClient
  attr_accessor :connection
  attr_accessor :space
  attr_accessor :client

  def initialize(email, password, space = nil)
    client = Podio::Client.new
    client.get_access_token(email, password)

    Podio.client = client

    self.space  = space
    self.client = client
  end

  def spaces
    found_spaces = []
    orgs = Podio::Organization.find_all
    orgs.each do |org|
      (org["spaces"] || []).each do |part_space|
        found_spaces << part_space["space_id"]
      end
    end
    found_spaces
  end

  def tasks(s = space)
    client.connection.get("/task/?space=#{s}").body
  end

  def update_task(task_id, comment)
    Podio::Comment.create("task", task_id, :value => comment)
  end
end

