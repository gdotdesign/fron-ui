module UI
  module Behaviors
    module Transition
      def self.included(base)
        base.on :animationend, :on_transition_end
        base.on :webkitAnimationEnd, :on_transition_end
        base.on :oanimationend, :on_transition_end
        base.on :MSAnimationEnd, :on_transition_end
        base.register self, [:transition]
      end

      def on_transition_end(event)
        options = @transitions[event.animationName]
        send options[:callback] if options[:callback] && respond_to?(options[:callback])
      end

      def self.transition(item)
        name = "#{tag}-#{item[:args][0]}"
        options = item[:args][1]
        Fron::Sheet.add_animation name, options[:frames]
        @transitions ||= {}
        @transitions[name] = options
      end

      def transition!(name)
        name = "#{tag}-#{name}"
        options = @transitions[name]
        @style.animation = [name, options[:duration], options[:delay], 'both'].join(' ')
      end
    end
  end
end
