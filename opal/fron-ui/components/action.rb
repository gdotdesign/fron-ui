module UI
  class Action < Fron::Component
    include Behaviors::Keydown

    style cursor: :pointer,
          '&:focus, &:hover' => {
            color: ->  { Config.colors.focus },
            outline: :none
          }

    keydown [:enter, :space], :action

    def initialize
      super
      self[:tabindex] ||= 0
    end

    def action
      trigger :click
    end
  end
end
