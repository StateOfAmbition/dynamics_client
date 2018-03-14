module Dynamics
  module Client
    class Base
      attr_accessor :client, :attributes, :lookups, :params

      def initialize(attributes = {}, lookups = {})
        @attributes = attributes
        @lookups = lookups
      end

      def method_missing(method, *args, &block)
        value = !attributes.nil? && attributes.has_key?(method) ? attributes[method] : nil
        value = value.nil? && !lookups.empty? && lookups.has_key?("#{method}@odata.bind") ? lookups["#{method}@odata.bind"] : nil
        value || super
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
