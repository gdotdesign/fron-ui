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
        base.meta_def :transition do |animation_name, options|
          name = "#{tagname}-#{animation_name}"
          options[:animation_name] = name
          Fron::Sheet.add_animation name, options[:frames]
          @registry << { method: Transition.method(:init_transition),
                         args: [animation_name, options],
                         id: SecureRandom.uuid }
        end
      end

      # Handles animation end events, and
      # calls the callback if sepcified.
      #
      # @param event [DOM::Event] The event
      def on_transition_end(event)
        options = @transitions[event.animationName]
        send options[:callback] if options &&
                                   options[:callback] &&
                                   respond_to?(options[:callback])
        @transition_callback.call if @transition_callback
      end

      # Adds the transitions animations to
      # the stylesheet.
      #
      # @param item [Hash] The item data
      def self.init_transition(item)
        name = item[:args][0]
        options = item[:args][1]
        @transitions ||= {}
        @transitions[name] = options
      end

      # Starts the transition with the given name.
      #
      # @param name [String] The name of the transition
      def transition!(name, &block)
        options = @transitions[name]
        @style.animation = [options[:animation_name],
                            options[:duration],
                            options[:delay], 'both'].join(' ')
        @transition_callback = block
      end
    end
  end
end
