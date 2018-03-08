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
        persisted? ? "#{self.class.resource_name}(#{id})" : self.class.resource_name
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

  end
end
