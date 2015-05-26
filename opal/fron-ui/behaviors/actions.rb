module UI
  module Behaviors
    # Behaviors to handle basic method
    # delegation via **action** attributes
    # of the child components
    #
    # @author Gusztáv Szikszai
    # @since  0.1.0
    module Actions
      IS_TOUCH = `'ontouchstart' in window && !window._phantom`

      METHOD = IS_TOUCH ? :touchstart : :click

      # Sets up the behavior:
      #
      # * Sets up event for the action
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.on METHOD, '[action]', :handle_action
      end

      private

      # Handles the action event:
      #
      # * calls the method named as the
      #   targets action attribute
      # * stops the event
      #
      # @param event [DOM::Event] The event
      def handle_action(event)
        method = event.target[:action]
        return unless respond_to?(method)
        event.stop
        send method, event
      end
    end
  end
end
