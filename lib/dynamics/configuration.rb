module Dynamics
  module Client
    class Configuration < ::Api::Client::Configuration
      attr_accessor :hostname, :tenant_id, :client_id, :client_secret, :access_token, :api_version

    end
  end
end
