require "api_client"
require 'dynamics/http'

require_relative './dynamics/configuration.rb'
require_relative './dynamics/base.rb'
require_relative './dynamics/entity.rb'
require_relative './dynamics/response.rb'



module Dynamics
  module Client

    def self.http
      @http ||= Dynamics::Client::Http.new
      @http.hostname = "https://ncvosandbox.crm4.dynamics.com"
      @http.tenant_id = "67e7e0c8-1ed0-45d1-b0cc-cabb5020e034"
      @http.client_id = "9903d040-e73f-4f18-98b4-92fccfda8920"
      @http.client_secret = "fnxY++URXF6kkoapgr2iVw91qZwv5yEeMaz8xMgbB/0="
      @http.api_version = "8.2"
      @http
    end

    def self.config
      @@config ||= Dynamics::Client::Configuration.new
    end

    def self.setup
      yield config
    end

    def self.logger
      @logger ||= logger = Logger.new(STDOUT).tap do |l|
        l.level = Logger::INFO
      end
    end

    instance_eval do
      [:get, :post, :patch, :delete].each do |action|

        define_method(action) do |path, params = {}|
          http.send(action, path, params)
        end
      end
    end

    def self.method_missing(name, *args)
      config.send(name) if config.respond_to?(name)
    end

    extend self
  end
end
