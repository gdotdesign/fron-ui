module UI
  module Behaviors
    # Behavior for managing state into
    # search part of the location.
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module State
      # Sets up the behavior.
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.register self, [:state_changed]
      end

      # Sets up events for popstate to handle
      # back and forward buttons.
      #
      # @param item [Hash] The arguments
      def self.state_changed(item)
        method = item[:args][0]
        DOM::Window.on('popstate') { send method }
        timeout do
          send method
        end
      end

      # Returns the decoded state.
      #
      # @return The state
      def state
        StateSerializer.decode(`location.search`[1..-1])
      end

      # Sets the state
      #
      # @param new_state The new state
      def state=(new_state)
        return if state == new_state
        DOM::Window.state = '?' + StateSerializer.encode(new_state)
      end
    end
  end
end
