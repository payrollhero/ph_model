module PhModel
  module Concerns
    extend ActiveSupport::Autoload

    autoload :AttributeNestedValidation
    autoload :AttributeOfArrayTypeInitialization
    autoload :AttributeRequiredValidation
    autoload :AttributeTypeValidation
    autoload :InitializeCallback
    autoload :ValidatedFactory
  end
end
