module ActiveModel
  module Validations
    # Adds type validation to ActiveModel::Model.
    #
    # Usage:
    # @example
    #   class FooBar
    #     include ActiveModel::Model
    #
    #     attr_accessor :date
    #
    #     validates :date, type: Date
    #   end
    class TypeValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        classes = Array(options[:with] || options[:in])
        unless classes.any? { |klass| value.is_a? klass }
          allowed_classes = classes.to_sentence two_words_connector: " or ",
                                                last_word_connector: ", or "

          record.errors[attribute] << (options[:message] || "must be a #{allowed_classes}")
        end
      end
    end
  end
end
