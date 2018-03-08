module Dynamics
  module DashboardEndpoint

    def self.included(base)
      base.extend ClassMethods
      def initialize(args)
        super(args)
      end

    end

    module ClassMethods

      def client
        @@client ||= Dynamics::Http.new({hostname: 'https://dashboard.dynamics.io', base_endpoint: "https://dashboard.dynamics.io/#{Dynamics::Client.config.account}/"})
      end

    end
  end
end
