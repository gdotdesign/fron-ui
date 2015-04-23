module UI
  # Simple Button Component
  class Button < Fron::Component
    tag 'ui-button'

    style color: -> { UI.readable_color(Config.main_color) },
          fontFamily: -> { Config.font_family },
          background: -> { Config.main_color },
          display: 'inline-block',
          padding: '0.6em 1.5em',
          borderRadius: '0.15em',
          whiteSpace: :nowrap,
          textAlign: :center,
          userSelect: :none,
          cursor: :pointer,
          fontWeight: '600'
  end
end
