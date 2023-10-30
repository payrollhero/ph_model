module ActiveModel
  module Validations
    # Builds the inner validators for the collection items validator
    class CollectionItemsValidator::InnerValidatorBuilder
      class << self
        def build(validator_name, options)
          new(validator_name, options).build
        end
      end

      def initialize(validator_name, options)
        @validator_name = validator_name
        @options = options
      end

      def build
        validator_class.new **(inner_options.merge(attributes: [:base]))
      end

      private

      attr_reader :validator_name, :options

      def validator_class
        name = "#{validator_name.to_s.camelize}Validator"

        begin
          name.include?("::") ? name.constantize : ActiveModel::Validations.const_get(name)
        rescue NameError
          raise ArgumentError, "Unknown validator: '#{validator_name}'"
        end
      end

      def inner_options
        case options
        when TrueClass
          {}
        when Hash
          options
        when Range, Array
          { in: options }
        else
          { with: options }
        end
      end
    end
  end
end
