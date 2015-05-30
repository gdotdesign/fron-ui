module UI
  module Behaviors
    # Behavior for defining methods with
    # a confirmation dialog, the given method
    # only will be called if the user accepts.
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module Confirmation
      # Sets up the behavior.
      #
      # @param base [Fron::Component] The includer
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
