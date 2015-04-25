module UI
  module Behaviors
    module Actions
      IS_TOUCH = `'ontouchstart' in window && !window._phantom`

      METHOD = IS_TOUCH ? :touchstart : :click

      def self.included(base)
        base.on METHOD, '[action]', :handle_action
      end

      private

      def handle_action(event)
        event.stop
        method = event.target[:action]
        send method, event if respond_to? method
      end
    end
  end
end
