module UI
  # Title component
  #
  # Features:
  # * Align text (left / center / right )
  # * Bottom border
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Title < Fron::Component
    extend Forwardable

    tag 'ui-title'

    style borderBottom: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" },
          paddingBottom: -> { theme.spacing.em },
          fontFamily: -> { theme.font_family },
          '> span' => { fontSize: '1.6em',
                        fontWeight: 600 }

    component :span, :span

    def_delegators :span, :text, :text=

    # Sets the text align of the component
    #
    # @param value [Symbol] The alignment
    def align=(value)
      @style.textAlign = value
    end
  end
end
