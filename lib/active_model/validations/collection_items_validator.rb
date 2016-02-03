module ActiveModel
  module Validations
    # Adds collection items validation to ActiveModel::Model.
    #
    # Usage:
    # @example
    #   class FooBar
    #     include ActiveModel::Model
    #
    #     attr_accessor :kinds
    #
    #     validates :kinds, collection_items { type: Symbol, inclusion: { in: [:foo, :bar] } }
    #   end
    class CollectionItemsValidator < ActiveModel::EachValidator
      extend ActiveSupport::Autoload

      autoload :ArrayAttributeReader
      autoload :ArrayAttributeGetter
      autoload :InnerValidatorBuilder

      def initialize(*)
        super.tap { set_inner_validators }
      end

      def validate_each(record, attribute, value)
        if value.kind_of? Enumerable
          validate_collection(record, attribute, value)
        else
          record.errors.add attribute, 'must be a collection'
        end
      end

      private

      attr_reader :inner_validators

      def set_inner_validators
        inner_validation_options = options.except(:class)
        @inner_validators = inner_validation_options.map do |validator_name, inner_options|
          InnerValidatorBuilder.build validator_name, inner_options
        end
      end

      def validator_value_pairs_for(value)
        inner_validators.product(value.each_with_index.to_a)
      end

      def validate_collection(record, attribute, value)
        record.extend ArrayAttributeReader
        validator_value_pairs_for(value).each do |validator, (item, index)|
          validator.validate_each record, :"#{attribute}[#{index}]", item
        end
      end
    end
  end
end
