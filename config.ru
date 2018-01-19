require 'date'
Bundler.require(:default)
require_relative 'jobs/appannie/api_client'
require_relative 'jobs/appannie/parser'
require_relative 'jobs/appannie/model'


Dotenv.load

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application