module UI
  class Title < Fron::Component
    tag 'ui-title'

    style color: -> { Config.colors.font },
          fontFamily: -> { Config.font_family },
          borderBottomStyle: :solid,
          borderBottomWidth: -> { Config.border_size.em },
          borderBottomColor: -> { Config.colors.border },
          paddingBottom: -> { (Config.spacing / 3).em },
          fontSize: '1.5em',
          fontWeight: 600

    def align=(value)
      @style.textAlign = value
    end
  end
end
