module PhModel
  module Concerns
    # Validates factories.
    module ValidatedFactory
      extend ActiveSupport::Concern

      included do |model|
        class << model
          private :new
        end
      end

      # Validates factories.
      module ClassMethods
        def build(*args)
          new(*args).tap do |model|
            unless model.valid?
              raise ValidationFailed, "#{name} is invalid: #{model.errors.full_messages.join("\n")}"
            end
          end
        end
      end
    end
  end
end
