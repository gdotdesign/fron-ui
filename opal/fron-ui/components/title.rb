module UI
  class Title < Fron::Component
    tag 'ui-title'

    style color: -> { Config.colors.font },
          fontFamily: -> { Config.font_family },
          borderBottomStyle: :solid,
          borderBottomWidth: -> { (Config.size / 20).em },
          borderBottomColor: -> { Config.colors.border },
          paddingBottom: -> { (Config.spacing / 3).em },
          fontSize: '1.5em',
          fontWeight: 600
  end
end
