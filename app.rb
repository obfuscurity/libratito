require 'sinatra'
require 'rest-client'
require 'time'
require 'json'

module Libratito
  class Web < Sinatra::Base

    configure do
      enable :logging
    end

    before do
      content_type :json
    end

    helpers do
      def validates?(secret)
        ENV['TITO_WEBHOOK_TOKEN'].eql?(secret)
      end
    end

    post '/events/:name?' do
      source = params[:name]
      prefix = 'libratito.'

      p '1'
      p JSON.parse(request.body.read)
      p '2'
      tito_user_action = request.env['HTTP_X_WEBHOOK_NAME'] # ticket.{created,updated}
      p '3'
      tito_webhook_data = JSON.parse(request.body.read)
      p '4'

      halt unless validates?(tito_webhook_data['custom'])
      p '5'

      puts "source is #{source}"
      puts "user action is #{tito_user_action}"
      puts "webhook data is:"
      p '6'
      p tito_webhook_data
      p '7'

      #RestClient.post 'https://metrics-api.librato.com/v1/metrics'
      #RestClient.post 'https://metrics-api.librato.com/v1/annotations/monitorama-registration'
      200
    end

    get '/health' do
      200
      {'status' => 'ok'}.to_json
    end
  end
end

