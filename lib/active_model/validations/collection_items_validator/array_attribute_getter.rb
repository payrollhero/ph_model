module ActiveModel
  module Validations
    # Decides how to get the value from array or other type of attribute.
    class CollectionItemsValidator::ArrayAttributeGetter
      class << self
        def get(attribute, when_array:, when_normal:)
          new(attribute, when_array: when_array, when_normal: when_normal).get
        end
      end

      def initialize(attribute, when_array:, when_normal:)
        @attribute = attribute
        @when_array = when_array
        @when_normal = when_normal
      end

      def get
        if match_data
          when_array.call attibute_name, index
        else
          when_normal.call
        end
      end

      private

      attr_reader :attribute, :when_array, :when_normal

      def match_data
        @match_data ||= /\A(.*)\[\d*\]\Z/.match(attribute)
      end

      def attibute_name
        match_data[1].to_sym
      end

      def index
        match_data[2].to_i
      end
    end
  end
end
