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
    self.connection = Faraday.new("http#{"s" if ssl}://#{account}.zendesk.com/") do |builder|
      builder.use Faraday::Request::Yajl
      builder.use Faraday::Adapter::Logger
      builder.adapter Faraday.default_adapter
      builder.use Faraday::Response::Yajl
    end
    self.connection.basic_auth(email, password)
  end

  def user(id)
    connection.get("/users/#{id}.json").body
  end

  def create(requester, due_date, description)
    response = connection.post do |request|
      request.url "/tickets.json"
      request.headers["Content-Type"] = "application/json"
      request.headers["Accept"]       = "application/json"
      request.body = {
        :ticket => {
          :ticket_type_id  => 4,
          :description     => description,
          :requester_email => requester
        }
      }
    end
    response.headers['location'].match(/.+?(\d+)\.json/)[1]
  end

  def tasks(*task_ids)
    tasks = []
    task_ids.each do |task_id|
      response = connection.get("/tickets/#{task_id}.json")
      if response.status != 200
        raise "Invalid response: #{response.inspect}"
      else
        tasks << Task.new(self, response.body)
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
