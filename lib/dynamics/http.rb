module Dynamics
  module Client
    class Http < ::Api::Client::Base
      attr_accessor :base_endpoint, :hostname, :tenant_id, :client_id, :client_secret, :access_token, :api_version

      def parse(response)
        Dynamics::Client.logger.info "[Dynamics::Client] response: #{response.inspect}"
        Dynamics::Client.logger.info "[Dynamics::Client] headers: #{response.headers.inspect}"
        begin
          document = JSON.parse(response.body)
          data = document.has_key?("value") ? document["value"] : document
          Response.new(response.code, response.headers, data).tap do |r|
            Dynamics::Client.logger.info "[Dynamics::Client] response: status #{r.status} data: #{r.data.inspect}" if log_response?
          end
        rescue JSON::ParserError => e
          Dynamics::Client.logger.debug "[Dynamics::Client] response headers: #{response.headers.inspect}" if log_response?
          Response.new(response.code, response.headers, response.body)
        end
      end

      def base_endpoint
        @base_endpoint ||= "#{hostname}/api/data/v#{api_version}/"
      end

      def log_response?
        Dynamics::Client.config.logger_active
      end

      private

        def header_params
          {content_type:  content_type, authorization: "Bearer #{access_token}"}
        end

        def content_type
          "application/json"
        end

        def authorisation_endpoint
          "https://login.windows.net/#{tenant_id}/oauth2/token"
        end

        def generate_token
          response = request(authorisation_endpoint, authorisation_params, :post)
          raise "invalid token" unless response.success
          self.access_token= response.data["access_token"]
          self.access_token_expires_at= Time.at(response.data["expires_on"].to_i)
          response.data["access_token"]
        end

        def authorisation_params
          {grant_type: 'client_credentials', client_id: client_id, client_secret: client_secret, resource: hostname}
        end

        def default_config
          {hostname: Dynamics::Client.hostname, tenant_id: Dynamics::Client.tenant_id, client_id: Dynamics::Client.client_id, client_secret: Dynamics::Client.client_secret, api_version: Dynamics::Client.api_version }
        end
    end
  end
end
