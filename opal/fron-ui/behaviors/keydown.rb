module UI
  module Behaviors
    # Behavior for managing key presses
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module Keydown
      class << self
        TYPES = %w(keyup keydown)

        # Sets up the behavior.
        #
        # @param base [Fron::Component] The includer
        def included(base)
          base.register self, TYPES
        end

        TYPES.each do |type|
          define_method type do |item|
            on type do |event|
              keys = Array(item[:args].first)
              break unless keys.include?(event.key)
              event.stop
              send item[:args][1], event
            end
          end
        end
      end
    end
  end
end
