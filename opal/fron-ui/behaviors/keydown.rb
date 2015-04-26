module UI
  module Behaviors
    module Keydown
      def self.included(base)
        base.register self, [:keydown]
      end

      def self.keydown(item)
        on :keyup do |event|
          break unless item[:args].first.include?(event.key)
          event.stop
          send item[:args][1]
        end
      end
    end
  end
end
