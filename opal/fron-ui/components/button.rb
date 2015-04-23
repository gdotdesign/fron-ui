module UI
  # Simple Button Component
  class Button < Base
    tag 'ui-button'

    style fontFamily: -> { Config.font_family },
          display: 'inline-block',
          padding: -> { "0 #{(Config.spacing * 1.8).em}" },
          borderRadius: -> { Config.border_radius.em },
          whiteSpace: :nowrap,
          textAlign: :center,
          userSelect: :none,
          cursor: :pointer,
          height: -> { Config.size.em },
          lineHeight: -> { Config.size.em },
          fontWeight: '600',
          overflow: :hidden,
          textOverflow: :ellipsis,
          '&[shape=square]' => {
            justifyContent: :center,
            alignItems: :center,
            display: :flex,
            height: -> { Config.size.em },
            minWidth: -> { Config.size.em },
            padding: '0',
          },
          '&[disabled]' => {
            opacity: 0.4
          }

    Config.colors.to_h.keys.each do |type|
      style "&[type=#{type}]" => { color: -> { UI.readable_color(Config.colors[type]) },
                                   background: -> { Config.colors[type] } }
    end

    def initialize
      super
      self[:tabindex] = 0
      self[:type] ||= :primary
    end
  end
end
