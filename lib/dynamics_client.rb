require "api_client"
require 'dynamics_client/http'

require_relative './dynamics_client/configuration.rb'
require_relative './dynamics_client/base.rb'
require_relative './dynamics_client/resource.rb'



module Dynamics
  module Client

    def self.http
      @http ||= Dynamics::Http.new
    end

    def self.config
      @@config ||= Dynamics::Configuration.new
    end

    def self.setup
      yield config
    end

    instance_eval do
      [:get, :post, :patch, :delete].each do |action|

        define_method(action) do |path, params|
          http.send(path, params)
        end
      end
    end

    def self.method_missing(name, *args)
      config.send(name) if config.respond_to?(name)
    end

    extend self
  end
end
