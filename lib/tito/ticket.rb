module Dynamics
  class Ticket < Dynamics::Resource
    include Eventable, DashboardEndpoint

    class << self

      def void(event_slug, id, resell = true)
        self.client.post([event_slug, resource_type, id, "voids"].join("/"), {void: {resell: resell}})
      end

      def un_void(event_slug, id)
        self.client.delete([event_slug, resource_type, id, "voids"].join("/"))
      end

      def attributes
        [:answers, :first_name, :last_name, :email, :release_id, :company_name, :phone_number, :price, :tags, :test_mode, :notify]
      end
    end
  end
end


