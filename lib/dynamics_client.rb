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
