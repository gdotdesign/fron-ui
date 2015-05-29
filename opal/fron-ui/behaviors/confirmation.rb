module UI
  module Behaviors
    # Confirmation
    module Confirmation
      def self.included(base)
        base.meta_def :confirmation do |name, message|
          base.define_method "confirm_#{name}" do |*args|
            break if message && !confirm(message)
            send name, *args
          end
        end
      end
    end
  end
end
