module UI
  module Behaviors
    # Behavior for managing style transitions.
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module Transition
      # Sets up the behavior:
      #
      # * Listens on animation end events (prefixed)
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.on :animationend, :on_transition_end
        base.on :webkitAnimationEnd, :on_transition_end
        base.on :oanimationend, :on_transition_end
        base.on :MSAnimationEnd, :on_transition_end
        base.register self, [:transition]
      end

      # Handles animation end events, and
      # calls the callback if sepcified.
      #
      # @param event [DOM::Event] The event
      def on_transition_end(event)
        options = @transitions[event.animationName]
        send options[:callback] if options[:callback] && respond_to?(options[:callback])
        send @transition_callback if @transition_callback
      end

      # Adds the transitions animations to
      # the stylesheet.
      #
      # @param item [Hash] The item data
      def self.transition(item)
        name = "#{tag}-#{item[:args][0]}"
        options = item[:args][1]
        Fron::Sheet.add_animation name, options[:frames]
        @transitions ||= {}
        @transitions[name] = options
      end

      # Starts the transition with the given name.
      #
      # @param name [String] The name of the transition
      def transition!(name, &block)
        name = "#{tag}-#{name}"
        options = @transitions[name]
        @style.animation = [name, options[:duration], options[:delay], 'both'].join(' ')
        @transition_callback = block
      end
    end
  end
end
