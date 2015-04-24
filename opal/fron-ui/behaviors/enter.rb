module Behaviors
  # Enter Behavior
  module Enter
    # Registers itself on the included component
    #
    # @param base [Fron::Componentn] The component
    def self.included(base)
      base.register self, [:enter]
    end

    # Creates modals from the registry
    #
    # @param registry [Array] The registry
    def self.enter(item)
      method = item[:args].first
      on :keydown do |event|
        send(method, event) if event.key == :enter
      end
    end
  end
end
