module Dynamics
  module Client
    class Entity < Dynamics::Client::Base

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
        persisted? ? "#{self.class.endpoint}(#{id})" : self.class.endpoint
      end

      def persisted?
        !!(id)
      end

      class << self
        def attributes
          raise "Dynamics::Resource must implement self.attributes"
        end

        def endpoint
          resource_type
        end

        def lookups
          {}
        end

        def all(params = {})
          client.get(resource_type, params)
        end

        def find(id, params = {})
          client.get("#{endpoint}(#{id})", params)
        end

        def destroy(id)
          client.delete("#{endpoint}(#{id})")
        end

        def resource_name
          @resouce_name ||= "#{resource_prefix}_#{self.name.split('::').last.downcase}"
        end

        def resource_type
          "#{resource_name}#{resource_plural}"
        end

        def resource_plural
          match = /^(\w+)(?:y)$/i.match(resource_name)
          match ? "ies" : "s"
        end

        def resource_prefix
          raise "Dynamics::Resource must implement #resource_prefix"
        end

      end

      private

        def generate_params
          params_hash.to_json
        end

        def params_hash
          non_empty_attributes.merge(non_empty_lookups)
        end

        def non_empty_params(type)
          self.send(type).delete_if { |k, v| v.nil? }
        end

        def non_empty_attributes
          non_empty_params(:attributes)
        end

        def non_empty_lookups
          non_empty_params(:lookups)
        end

    end
  end
end
