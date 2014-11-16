require 'sinatra'
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
      def authenticate
        Librato::Metrics.authenticate ENV['LIBRATO_USER'], ENV['LIBRATO_TOKEN']
      end
    end

    post '/events/:name?' do
      source = params[:name]
      prefix = 'libratito.ticket'

      tito_user_action = request.env['HTTP_X_WEBHOOK_NAME'].split('.').last
      tito_data = @request_payload

      halt unless validates?(tito_data['custom'])

      authenticate

      queue = Librato::Metrics::Queue.new
      queue.add "#{prefix}.#{tito_user_action}" => { :source => source, :value => 1 }
      queue.add "#{prefix}.type.#{tito_data['release'].gsub(/\s+/, '_')}" => { :source => source, :value => 1 }
      queue.add "#{prefix}.price" => { :source => source, :value => tito_data['price'].to_f }
      if !tito_data['release_price'].nil?
        queue.add "#{prefix}.release_price" => { :source => source, :value => tito_data['release_price'].to_f }
      end
      if !tito_data['discount_code_used'].empty?
        queue.add "#{prefix}.discount_code.#{tito_data['discount_code_used']}" => { :source => source, :value => 1 }
      end
      queue.submit

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

