module ActiveModel
  module Validations
    # Adds support for validation to read attribute names like foo[0].
    # Mainly used to validate collections.
    module CollectionItemsValidator::ArrayAttributeReader
      def read_attribute_for_validation(attribute)
        CollectionItemsValidator::ArrayAttributeGetter.get(
          attribute,
          when_array: -> (attribute_name, index) { super(attribute_name)[index] },
          when_normal: -> { super }
        )
      end
    end
  end
end
