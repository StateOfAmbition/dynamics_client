module Dynamics
  class Activity < Dynamics::Resource
    include Eventable, DashboardEndpoint

    class << self
      def attributes
        [:name, :capacity, :private, :release_ids]
      end
    end

  end
end
