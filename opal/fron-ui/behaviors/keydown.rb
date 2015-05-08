module UI
  module Behaviors
    # Keydown
    module Keydown
      def self.included(base)
        base.register self, [:keydown]
      end

      def self.keydown(item)
        on :keydown do |event|
          _handle_keys Array(item[:args].first), item[:args][1], event
        end
      end

      def _handle_keys(keys, action, event)
        return unless keys.include?(event.key)
        event.stop
        send action, event
      end

      def self.keyup(item)
        on :keyup do |event|
          _handle_keys Array(item[:args].first), item[:args][1], event
        end
      end
    end
  end
end
