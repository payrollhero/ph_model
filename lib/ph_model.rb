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

  include ActiveAttr::BasicModel
  include ActiveAttr::AttributeDefaults
  include ActiveAttr::QueryAttributes
  include ActiveAttr::MassAssignment

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

  autoload :Concerns
  autoload :ValidationFailed

  include Concerns::ValidatedFactory
end
