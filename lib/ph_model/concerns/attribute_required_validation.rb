module PhModel
  module Concerns
    module AttributeRequiredValidation
      extend ActiveSupport::Concern

      included do |other|
        other.validate :validate_required_attributes
      end

      def validate_required_attributes
        self.class.attributes.each do |attribute_name, info|
          if info[:required] && send(attribute_name).blank?
            errors.add(attribute_name, :empty)
          end
        end
      end
    end
  end
end
