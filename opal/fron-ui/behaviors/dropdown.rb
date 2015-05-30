module UI
  module Behaviors
    # Behavior for managing opening / closing
    # of a dropdown.
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module Dropdown
      # Sets up the behavior.
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.register self, [:dropdown]
      end

      # Handles the initialization of
      # the component
      #
      # @param item [Hash] The arguments
      def self.dropdown(item)
        input, dropdown = item[:args].map { |id| instance_variable_get("@#{id}") }
        input.on(:focus) { dropdown.open }
        input.on(:blur)  { dropdown.close }
      end
    end
  end
end
