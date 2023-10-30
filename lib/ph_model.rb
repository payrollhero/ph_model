require 'active_support/all'
require 'active_model'
require 'active_attr'

ActiveModel::Validations # ensure its loaded since we're patching it

module ActiveModel
  module Validations
    extend ActiveSupport::Autoload
    autoload :TypeValidator
    autoload :CollectionItemsValidator
  end
end

# PayrollHero's mashup of ActiveModel and ActiveAttr with some of our own twists
module PhModel
  extend ActiveSupport::Concern
  extend ActiveSupport::Autoload

  autoload :Concerns
  autoload :ValidationFailed

  include ActiveAttr::BasicModel
  include ActiveAttr::AttributeDefaults
  include ActiveAttr::QueryAttributes
  include ActiveAttr::MassAssignment

  include Concerns::InitializeCallback
  include Concerns::AttributeRequiredValidation
  include Concerns::AttributeTypeValidation
  include Concerns::AttributeNestedValidation
  include Concerns::AttributeOfArrayTypeInitialization

  def as_json(*)
    {}.tap do |hash|
      self.class.attributes.each do |attribute_name, _info|
        hash[attribute_name] = send(attribute_name).as_json
      end
    end
  end

  def inspect
    attr_info = self.class.attributes.map { |attr_name, info| "#{attr_name}: #{self.send(attr_name).inspect}" }
    "#<#{self.model_name} #{attr_info.join(', ')}>"
  end

  # Monkey patch #assign_attributes inside ActiveAttr::MassAssignment
  # so that it doesn't blindly ignore attempting to assign attributes which do not
  # exist
  #
  # TODO: try to submit something upstream to deal with this
  def assign_attributes(new_attributes, options = {})
    sanitized_new_attributes = sanitize_for_mass_assignment_if_sanitizer new_attributes, options

    sanitized_new_attributes.each do |name, value|
      writer = "#{name}="
      # originally:
      # send writer, value if respond_to? writer
      send writer, value
    end if sanitized_new_attributes
  end

  include Concerns::ValidatedFactory
end
