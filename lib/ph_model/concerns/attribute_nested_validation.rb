module PhModel
  module Concerns
    module AttributeNestedValidation
      extend ActiveSupport::Concern

      included do |other|
        other.validate :validate_nested_attributes
      end

      def validate_nested_attributes
        self.class.attributes.each do |attribute_name, info|
          value = send(attribute_name)
          if info[:type].is_a? Array
            if value.respond_to? :each_with_index
              value.each_with_index do |item_value, index|
                check_one(item_value, "#{attribute_name}[#{index}]")
              end
            end
          else
            check_one(value, attribute_name)
          end
        end
      end

      def check_one(value, attribute_name)
        return if !value.respond_to?(:valid?) || !value.respond_to?(:errors) || !value.errors.present? || value.valid?
        value.errors.full_messages.each do |message|
          errors.add(:base, "#{attribute_name}.#{message}")
        end
      end
    end
  end
end
