module UI
  class Slider < Drag
    tag 'ui-slider'

    style height: -> { theme.size.em },
          width: -> { (theme.size * 6).em },
          background: :transparent,
          cursor: :pointer,
          'ui-drag-handle' => {
            background: -> { colors.primary },
            top: '50%',
            pointerEvents: :auto,
            width: 1.5.em,
            height: 1.5.em
          },
          '&:before' => {
            content: "''",
            position: :absolute,
            background: -> { dampen colors.primary, 0.5 },
            top: '50%',
            height: 0.8.em,
            marginTop: -0.4.em,
            borderRadius: 0.4.em,
            left: 0,
            right: 0
          }

    def initialize
      super
      @vertical = false
      self[:tabindex] ||= 0
    end
  end
end
