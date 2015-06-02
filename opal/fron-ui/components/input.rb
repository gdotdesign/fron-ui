module UI
  # Input component, basically the input element wrapped
  # and styled.
  #
  # @author Gusztáv Szikszai
  # @since  0.1.0
  class Input < Base
    tag 'input[type=text]'

    attribute_accessor :placeholder
    attribute_accessor :readonly, default: false

    style color: -> { dampen readable_color(colors.input), 0.35 },
          borderRadius: -> { theme.border_radius.em },
          padding: -> { "0 #{theme.spacing.em}" },
          fontFamily: -> { theme.font_family },
          lineHeight: -> { theme.size.em },
          background: -> { colors.input },
          height: -> { theme.size.em },
          fontSize: :inherit,
          border: 0,
          '&:focus' => {
            boxShadow: -> { theme.focus_box_shadow },
            outline: :none
          }
  end
end
