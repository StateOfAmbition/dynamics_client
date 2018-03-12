module Dynamics
  module Client
    class Response < ::Api::Client::Response

      def resources
        @resources ||= data.is_a?(Array) ? data.map{|d| OpenStruct.new(d)} : []
      end

      def resource
        return nil if data.blank?
        @resource ||= data.is_a?(Array) ? resources.first : OpenStruct.new(data)
      end

      def resource_id(field)
        resource&.send(field) || extract_id_from_headers
      end

      private

        def extract_id_from_headers
          headers.has_key?(:odata_entityid) ? entity_id_regex : nil
        end

        def entity_id_regex
          headers[:odata_entityid] =~ /\((.*)\)\z/
          $1
        end
    end


  end
end
