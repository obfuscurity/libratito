require 'sinatra'
require 'rest-client'
require 'librato/metrics'
require 'yajl'

module Libratito
  class Web < Sinatra::Base

    configure do
      enable :logging
    end

    before do
      content_type :json
      request.body.rewind
      @request_payload = Yajl::Parser.new.parse(request.body.read)
    end

    helpers do
      def validates?(secret)
        ENV['TITO_WEBHOOK_TOKEN'].eql?(secret)
      end
    end

    post '/events/:name?' do
      source = params[:name]
      prefix = 'libratito.ticket'

      tito_user_action = request.env['HTTP_X_WEBHOOK_NAME'].split('.').last
      tito_data = @request_payload

      halt unless validates?(tito_data['custom'])

      #gauge "#{prefix}.#{tito_user_action} 1"
      #gauge "#{prefix}.price #{tito_data['price']}"
      #gauge "#{prefix}.release_price #{tito_data['release_price']}"
      #gauge "#{prefix}.discount_code.#{tito_data['discount_code_used']} 1"
      #gauge "#{prefix}.type.#{tito_data['release']} 1"

      #annotation :title => "ticket #{tito_user_action}",
      #            :source => source,
      #            :description => "#{tito_data['name']} #{tito_user_action} ticket #{reference}"


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

