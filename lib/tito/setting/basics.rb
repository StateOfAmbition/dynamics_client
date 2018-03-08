module Dynamics
  module Setting
    class Basics < Dynamics::Setting::Base

      class << self
        def attributes
          [:email_address, :slug, :domain, :private, :meta_robots]
        end
      end
    end
  end
end
