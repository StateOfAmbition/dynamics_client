module Dynamics
  module Client
    class Http < ::Api::Client::Base
      attr_accessor :base_endpoint, :hostname, :tenant_id, :client_id, :client_secret, :access_token, :api_version

      def parse(status, body)
        begin
          document = JSON.parse(body)
          data = document.has_key?(:value) ? document["value"] : document
          ::Api::Client::Response.new(status, data).tap do |r|
            puts "[API::Client] Response: status #{r.status} data: #{r.data.inspect}" if log_response?
          end
        rescue JSON::ParserError => e
          ::Api::Client::Response.new(status, body)
        end
      end

      def base_endpoint
        @base_endpoint ||= "#{hostname}/api/data/v#{api_version}/"
      end

      private
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
