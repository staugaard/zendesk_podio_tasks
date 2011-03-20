require 'json'

# client = ZendeskClient.new("example", "hello@example.com", "123456")
# tasks = client.tasks(... task ids ...)
# tasks.first.comments.each do |comment|
#   comment.author
#   comment.value
# end
class ZendeskClient

  attr_accessor :connection

  def initialize(account, email, password, ssl = true)
    self.connection = Faraday.new("http#{"s" if ssl}://#{account}.zendesk.com/")
    self.connection.basic_auth(email, password)
  end

  def user(id)
    JSON.parse(connection.get("/users/#{id}.json").body)
  end

  def create(requester, due_date, description)
    connection.post do |request|
      request.url = "/ticket.json"
      request.headers["Content-Type"] = "application/json"
      request.body = {
        :ticket => {
          :type => 4,
          :description     => descroption,
          :requester_email => requester
        }
      }
    end
  end

  def tasks(*task_ids)
    tasks = []
    task_ids.each do |task_id|
      response = connection.get("/tickets/#{task_id}.json")
      if response.status != 200
        raise "Invalid response: #{response.inspect}"
      else
        tasks << Task.new(self, JSON.parse(response.body))
      end
    end
    tasks
  end

  class Task
    attr_accessor :json
    attr_accessor :client

    def initialize(client, json)
      self.client = client
      self.json   = json
    end

    def id
      json["nice_id"]
    end

    def value
      json["value"]
    end

    def comments
      @comments ||= begin
        resolved = []
        json["comments"].each do |comment|
          author = client.user(comment["author_id"])["name"]
          resolved << Comment.new(author, comment["created_at"], comment["value"])
        end
        resolved
      end
    end

    def to_s
      "Task #{id}"
    end
  end

  class Comment < Struct.new(:author, :created_at, :value)
  end
end
