module PhModel
  module Concerns
    module AttributeOfArrayTypeInitialization
      extend ActiveSupport::Concern

      included do |other|
        other.after_initialize :initialize_array_type_attributes
      end

      def initialize_array_type_attributes
        self.class.attributes.each do |attribute_name, info|
          if info[:type].kind_of?(Array)
            send("#{attribute_name}=", []) unless send(attribute_name).present?
          end
        end
      end
    end
  end
end
