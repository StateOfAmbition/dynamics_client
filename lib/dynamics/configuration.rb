module Dynamics
  class Configuration
    attr_accessor :hostname, :client_id, :client_secret, :access_token, :api_version

    def hostname
      @hostname
    end

    def api_version
      @api_version || 8.2
    end
  end
end
