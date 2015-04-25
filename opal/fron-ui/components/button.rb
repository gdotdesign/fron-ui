module UI
  # Simple Button Component
  class Button < Action
    tag 'ui-button'

    style fontFamily: -> { Config.font_family },
          display: 'inline-block',
          padding: -> { "0 #{(Config.spacing * 1.8).em}" },
          borderRadius: -> { Config.border_radius.em },
          whiteSpace: :nowrap,
          textAlign: :center,
          userSelect: :none,
          height: -> { Config.size.em },
          lineHeight: -> { Config.size.em },
          fontWeight: '600',
          overflow: :hidden,
          textOverflow: :ellipsis,
          '&[type]:focus' => {
            boxShadow: -> { Config.focus_box_shadow }
          },
          '&[shape=square]' => {
            justifyContent: :center,
            alignItems: :center,
            display: :flex,
            height: -> { Config.size.em },
            minWidth: -> { Config.size.em },
            padding: '0'
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
      self[:type] ||= :primary
    end
  end
end
