module UI
  module Behaviors
    # Confirmation
    module Confirmation
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
