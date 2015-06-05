module UI
  # Behaviors
  module Behaviors
    # Behavior for managing components
    # that can respond to **action** - enter / space
    #
    # @author Gusztáv Szikszai
    # @since  0.1.0
    module Action
      # Sets up the behavior:
      #
      # * Includes keydown behavior
      # * Sets styles for :focus and :hover states
      # * Sets up actions for enter and space
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.include Behaviors::Keydown
        base.style cursor: :pointer,
                   userSelect: :none,
                   '> *' => { pointerEvents: :none },
                   '&:focus, &:hover' => {
                     color: ->  { colors.focus },
                     outline: :none
                   }

        base.keydown [:enter, :space], :action
      end

      # Action method, to be overriden.
      #
      # * Triggers click event
      #
      # @abstract
      def action
        trigger :click
      end
    end
  end
end
