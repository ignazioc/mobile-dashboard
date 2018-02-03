require 'date'

Bundler.require(:default)
require 'dashing'

Dotenv.load

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  set :template_languages, %i[html erb]

  helpers do
    def protected!
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
