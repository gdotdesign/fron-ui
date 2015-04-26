module UI
  class Title < Fron::Component
    tag 'ui-title'

    style color: -> { colors.font },
          fontFamily: -> { theme.font_family },
          borderBottomStyle: :solid,
          borderBottomWidth: -> { theme.border_size.em },
          borderBottomColor: -> { colors.border },
          paddingBottom: -> { (theme.spacing / 3).em },
          fontSize: '1.5em',
          fontWeight: 600

    def align=(value)
      @style.textAlign = value
    end
  end
end
