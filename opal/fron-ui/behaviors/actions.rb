module UI
  module Behaviors
    # Actions
    module Actions
      IS_TOUCH = `'ontouchstart' in window && !window._phantom`

      METHOD = IS_TOUCH ? :touchstart : :click

      def self.included(base)
        base.on METHOD, '[action]', :handle_action
      end

      private

      def handle_action(event)
        method = event.target[:action]
        return unless respond_to?(method)
        event.stop
        send method, event
      end
    end
  end
end
