module UI
  module Behaviors
    # Remove
    module Remove
      def self.included(other)
        other.meta_def :remove_confirmation do |message|
          @remove_confirmation = message if message
          @remove_confirmation
        end
      end

      def remove!
        message = self.class.remove_confirmation
        return if message && !confirm(message)
        super
      end
    end
  end
end
