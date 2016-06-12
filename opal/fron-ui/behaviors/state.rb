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
        search = `location.search`[1..-1]
        StateSerializer.decode(`window.atob(#{search})`)
      rescue
        ''
      end

      # Sets the state
      #
      # @param new_state The new state
      def state=(new_state, options = {})
        return if state == new_state
        path = yield if block_given?
        hash = `window.btoa(#{StateSerializer.encode(new_state)})`
        new_url = path.to_s + '?' + hash
        if options.to_h[:replace]
          DOM::Window.replace_state new_url
        else
          DOM::Window.state = new_url
        end
      end

      alias set_state state=
    end
  end
end
