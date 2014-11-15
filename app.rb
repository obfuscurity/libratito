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
      #halt unless validated?
      content_type :json
    end

    helpers do
      def validated?
        # check TITO_WEBHOOK_TOKEN here
        return true
      end
    end

    post '/event/?' do
      p request.env
      # check X-Webhook-Name for 'created' or 'updated'
      #RestClient.post 'https://metrics-api.librato.com/v1/metrics'
      #RestClient.post 'https://metrics-api.librato.com/v1/annotations/monitorama-registration'
      # XXX use 'pdx2015' as the source
      200
    end

    get '/health' do
      200
      {'status' => 'ok'}.to_json
    end
  end
end

