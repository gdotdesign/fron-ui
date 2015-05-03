module UI
  module Behaviors
    # Remove
    module Remove
      def self.included(other)
        other.meta_def :confirmation do |name, message|
          other.define_method "confirm_#{name}" do |*args|
            break if message && !confirm(message)
            send name, *args
          end
        end
      end
    end
  end
end
