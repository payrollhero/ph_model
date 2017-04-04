module PhModel
  module Concerns

    # Adds support for defining callbacks around initialize
    module InitializeCallback
      extend ActiveSupport::Concern

      included do |other|
        other.define_model_callbacks :initialize
      end

      def initialize(attributes = nil, options = {})
        run_callbacks :initialize do
          super
        end
      end
    end
  end
end
