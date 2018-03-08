module Dynamics
  class Question < Dynamics::Resource
    include Eventable

    class << self
      def attributes
        [:title, :description, :required, :options, :options_free_text_field, :include_free_text_field, :field_type]
      end
    end

  end
end
