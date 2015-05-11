module UI
  module Behaviors
    # Actions
    module Action
      def self.included(base)
        base.include Behaviors::Keydown
        base.style cursor: :pointer,
                   '&:focus, &:hover' => {
                     color: ->  { colors.focus },
                     outline: :none
                   }

        base.keydown [:enter, :space], :action
      end

      def action
        trigger :click
      end
    end
  end
end
