module Dynamics
  module Client
    class Resource < Dynamics::Client::Base

      def sync
        response = persisted? ? update : create
        block_given? ? (yield response) : response
      end

      def get(url_params = {})
        self.class.client.get(endpoint, url_params)
      end

      def create
        self.class.client.post(endpoint, params)
      end

      def update
        self.class.client.patch(endpoint, params)
      end

      def destroy
        self.class.client.delete(endpoint)
      end

      def endpoint
        persisted? ? "#{self.class.resource_type}(#{id})" : self.class.resource_type
      end

      def persisted?
        !!(id)
      end

      class << self
        def attributes
          raise "Dynamics::Resource must implement self.attributes"
        end

        def all(params = {})
          client.get(resource_type, params)
        end

        def find(id)
          client.get("#{resource_type}(#{id})", params)
        end

        def resource_name
          @resouce_name ||= "#{resource_prefix}_#{self.name.split('::').last.
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").downcase}"
        end

        def resource_type
          "#{resource_name}#{resource_plural}"
        end

        def resource_plural
          match = /^(\w+)(?:y)$/i.match(resource_name)
          match ? (match[1] + "ies") : (resource_name + "s")
        end

        def resource_prefix
          raise "Dynamics::Resource must implement #resource_prefix"
        end

      end

      private

        def generate_params
          params_hash
        end

        def params_hash
          self.class.attributes.inject({}){|params, attr| params[attr] = send(attr); params}.delete_if { |k, v| v.nil? }
        end

    end
  end
end
