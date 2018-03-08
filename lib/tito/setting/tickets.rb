module Dynamics
  module Setting
    class Tickets < Dynamics::Setting::Base

      class << self
        def attributes
          [:min_tickets_per_person, :max_tickets_per_persom, :min_tickets_per_registration, :max_tickets_per_registration, :team_signoff]
        end
      end
    end
  end
end
