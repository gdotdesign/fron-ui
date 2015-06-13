module UI
  module Behaviors
    module State
      def self.included(base)
        base.register self, [:state_changed]
      end

      def self.state_changed(item)
        method = item[:args][0]
        DOM::Window.on('popstate') { send method }
        send method
      end

      def state
        StateSerializer.decode(`location.search`[1..-1])
      end

      def state=(new_state)
        return if state == new_state
        DOM::Window.state = '?' + StateSerializer.encode(new_state)
      end
    end
  end
end
