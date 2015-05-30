module UI
  # Horizontal range / slider component
  #
  # @attr value [Float] The value
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Slider < Drag
    tag 'ui-slider'

    style minWidth: -> { (theme.size * 6).em },
          height: -> { theme.size.em },
          background: :transparent,
          cursor: :pointer,
          'ui-drag-handle' => { borderRadius: -> { theme.border_radius.em },
                                background: -> { colors.primary },
                                pointerEvents: :auto,
                                height: 1.5.em,
                                width: 1.5.em,
                                top: '50%' },
          '&:focus' => { outline: :none,
                         '&:before' => { boxShadow: -> { theme.focus_box_shadow } } },
          '&:before' => { borderRadius: -> { theme.border_radius.em },
                          background: -> { colors.input },
                          position: :absolute,
                          marginTop: -0.4.em,
                          height: 0.8.em,
                          content: "''",
                          top: '50%',
                          right: 0,
                          left: 0 }

    on :mousedown, :focus

    # Initailizes the component by
    # seting tabindex and restricting
    # it to be horizontal
    def initialize
      super
      @vertical = false
      self[:tabindex] ||= 0
    end

    alias_method :value, :value_x
    alias_method :value=, :value_x=
  end
end
