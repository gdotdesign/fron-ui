module UI
  module Behaviors
    # Keydown
    module Keydown
      class << self
        TYPES = %w(keyup, keydown)

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
