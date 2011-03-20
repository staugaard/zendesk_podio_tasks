require 'dm-core'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.sqlite3")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end
