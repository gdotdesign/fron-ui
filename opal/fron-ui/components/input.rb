module UI
  class Input < Base
    tag 'input'

    style padding: -> { "0 #{Config.spacing.em}" },
          borderRadius: -> { Config.border_radius.em },
          fontFamily: -> { Config.fontFamily },
          color: -> { Config.colors.font },
          height: -> { Config.size.em },
          lineHeight: -> { Config.size.em },
          fontSize: :inherit,
          border: 0,
          '&::placeholder' => {
            fontWeight: 600
          }
  end
end
