module UI
  # Title
  class Title < Fron::Component
    extend Forwardable

    tag 'ui-title'

    style color: -> { colors.font },
          fontFamily: -> { theme.font_family },
          borderBottomStyle: :solid,
          borderBottomWidth: -> { theme.border_size.em },
          borderBottomColor: -> { colors.border },
          paddingBottom: -> { theme.spacing.em },
          span: {
            fontSize: '1.5em',
            fontWeight: 600
          }

    component :span, :span

    def_delegators :span, :text, :text=

    def align=(value)
      @style.textAlign = value
    end
  end
end
