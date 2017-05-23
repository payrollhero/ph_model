module PhModel
  module Concerns

    # This will validate any attribute defined with `type: `
    # the type value should be a class, or the special notation `[SomeClass]` which is meant to designate that this is
    # a collection of those classes
    #
    # `no_type_check: true` can be optionally passed to disable this check (other features might use the `type` column)
    module AttributeTypeValidation
      extend ActiveSupport::Concern

      included do |other|
        other.validate :ensure_typed_attributes_class
      end

      def ensure_typed_attributes_class
        self.class.attributes.each do |attribute_name, info|
          if info[:type] && !info[:no_type_check] && !type_match?(attribute_name)
            errors.add(attribute_name, "must be #{info[:type].inspect}, was #{type_summary(attribute_name)}")
          end
        end
      end

      def type_summary(attribute_name)
        value = send(attribute_name)
        case value
        when Array
          value.map { |val| val.respond_to?(:model_name) ? val.model_name.name : val.class.name }.uniq
        else
          value.class
        end
      end

      def type_match?(attribute_name)
        value = send(attribute_name)
        info = self.class.attributes[attribute_name]
        type = info[:type]

        case type
        when nil
          true
        when Array
          if type.count != 1
            raise ArgumentError, "don't know how to handle type: #{type.inspect}"
          else
            if value.kind_of? Array
              value.all? { |item| item.is_a?(type.first) }
            else
              false
            end
          end
        else
          if !info[:required] && value.nil?
            true
          else
            value.is_a?(type)
          end
        end
      end
    end
  end
end
