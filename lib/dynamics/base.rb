module Dynamics::Client
  class Base
    attr_accessor :client, :attributes, :params

    def initialize(attributes = {})
      @attributes = attributes
    end

    def method_missing(method, *args, &block)
      attributes.has_key?(method) ? attributes[method] : nil
    end

    def params
      @params ||= generate_params
    end

    class << self

      attr_reader :client

      def client
        @client ||= Dynamics::Client.http
      end

    end

  end
end
