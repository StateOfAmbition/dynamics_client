module Dynamics::Client
  class Resource < Dynamics::Client::Base

    def sync
      response = persisted? ? update : create
      block_given? ? (yield response) : response
    end

    def get(params = {})
      Dynamics::Base.get(endpoint, arams)
    end

    def create
      Dynamics::Base.post(endpoint, params)
    end

    def update
      Dynamics::Base.patch(endpoint, params)
    end

    def destroy
      Dynamics::Base.delete(endpoint)
    end

    class << self
      def attributes
        raise "Dynamics::Resource must implement self.attributes"
      end
    end
    private

      def endpoint
        persisted? ? "#{self.class.resource_type}(#{id})" : self.class.resource_type
      end

      def persisted?
        !!(id)
      end

      def generate_params
        attribute_hash
      end

      def attribute_hash
        self.class.attributes.map{|attr| send(attr)}.delete_if { |k, v| v.nil? }
      end

      def resource_prefix
        raise "Dynamics::Resource must implement #resource_prefix"
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

  end
end
