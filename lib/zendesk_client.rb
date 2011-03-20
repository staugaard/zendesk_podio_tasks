require 'json'

# client = ZendeskClient.new("example", "hello@example.com", "123456")
# tasks = client.tasks(... task ids ...)
# tasks.first.comments
class ZendeskClient

  attr_accessor :connection

  def initialize(account, email, password, ssl = true)
    self.connection = Faraday.new("http#{"s" if ssl}://#{account}.zendesk.com/")
    self.connection.basic_auth(email, password)
  end

  def tasks(*task_ids)
    tasks = []
    task_ids.each do |task_id|
      response = connection.get("/tickets/#{task_id}.json")
      if response.status != 200
        raise "Invalid response: #{response.inspect}"
      else
        tasks << Task.new(response.body)
      end
    end
    tasks
  end

  class Task
    attr_accessor :data

    def initialize(data)
      self.data = JSON.parse(data)
    end

    def comments
      data["comments"]
    end
  end

end
