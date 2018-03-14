module Dynamics
  module Client
    class Base
      attr_accessor :client

      def initialize(attributes = {})
        @attributes = attributes
      end

      def method_missing(method, *args, &block)
        return super if attributes.nil?
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
end
